data "aws_region" "selected" {
    current = true
}

data "aws_caller_identity" "current" {}

resource "aws_ecs_cluster" "cluster" {
    name = "${var.name}"
}

data "aws_ami" "coreos_stable" {
    most_recent = true
    owners = ["595879546273"]
    filter {
        name = "architecture"
        values = ["x86_64"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
    filter {
        name = "name"
        values = ["CoreOS-stable-*"]
    }
}

module "ec2_security_group" {
    source = "../security_group"
    vpc_id = "${var.vpc_id}"
    name = "${var.name}-ec2"
    all_internal = true
    all_outbound = true
    all_inbound_ssh = true
    all_inbound_http = true
    all_inbound_https = true
    group_inbound_nfs = true
    group_inbound_nfs_id = "${module.efs_security_group.id}"
}

module "efs_security_group" {
    source = "../security_group"
    vpc_id = "${var.vpc_id}"
    name = "${var.name}-efs"
    group_outbound_nfs = true
    group_outbound_nfs_id = "${module.ec2_security_group.id}"
    group_inbound_nfs = true
    group_inbound_nfs_id = "${module.ec2_security_group.id}"
}

data "template_file" "cloud_config" {
    template = "${var.cloud_config}"
    vars {
        aws_region = "${data.aws_region.selected.id}"
        efs_id = "${aws_efs_file_system.shared.id}"
        log_group_name = "${aws_cloudwatch_log_group.default.name}"
    }
}

resource "aws_efs_file_system" "shared" {
    creation_token = "persist"
    tags {
        Name = "${var.name}-shared"
    }
}

resource "aws_efs_mount_target" "nfs" {
    count = "${length(var.subnets)}"
    file_system_id = "${aws_efs_file_system.shared.id}"
    subnet_id = "${element(var.subnets, count.index)}"
    security_groups = ["${module.efs_security_group.id}"]
}

resource "aws_autoscaling_group" "cluster" {
    name = "${aws_launch_configuration.cluster.name}"
    max_size = "${var.instances_max}"
    min_size = "${var.instances_min}"
    desired_capacity = "${var.instances_desired}"
    launch_configuration = "${aws_launch_configuration.cluster.name}"
    vpc_zone_identifier = ["${var.subnets}"]
    tag {
        key = "Name"
        value = "${var.name}"
        propagate_at_launch = true
    }
    lifecycle = {
        create_before_destroy = true
    }
}

resource "aws_iam_role" "hook" {
    name = "${var.name}-hook"
    assume_role_policy = "${data.aws_iam_policy_document.hook_assume_role.json}"
}

data "aws_iam_policy_document" "hook_assume_role" {
    statement {
        sid = ""
        effect = "Allow"
        principals {
            type = "Service"
            identifiers = ["autoscaling.amazonaws.com"]
        }
        actions = ["sts:AssumeRole"]
    }
}

resource "aws_iam_role_policy" "hook" {
    name = "${var.name}-instance"
    role = "${aws_iam_role.hook.name}"
    policy = "${data.aws_iam_policy_document.hook_policy.json}"
}

data "aws_iam_policy_document" "hook_policy" {
    statement {
        sid = ""
        effect = "Allow"
        resources =  [
            "${aws_sns_topic.instance_launch.arn}",
            "${aws_sns_topic.instance_terminate.arn}"
        ]
        actions = ["sns:Publish"]
    }
}

resource "aws_sns_topic" "instance_launch" {
  name = "${var.name}-instance-launch"
}

resource "aws_sns_topic" "instance_terminate" {
  name = "${var.name}-instance-terminate"
}

resource "aws_autoscaling_lifecycle_hook" "instance_launch" {
    name = "${var.name}-launch"
    autoscaling_group_name = "${aws_autoscaling_group.cluster.name}"
    default_result = "CONTINUE"
    heartbeat_timeout = "${var.launch_delay}"
    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
    notification_target_arn = "${aws_sns_topic.instance_launch.arn}"
    role_arn = "${aws_iam_role.hook.arn}"
}

resource "aws_autoscaling_lifecycle_hook" "instance_terminate" {
    name = "${var.name}-terminate"
    autoscaling_group_name = "${aws_autoscaling_group.cluster.name}"
    default_result = "CONTINUE"
    heartbeat_timeout = "${var.terminate_delay}"
    lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
    notification_target_arn = "${aws_sns_topic.instance_terminate.arn}"
    role_arn = "${aws_iam_role.hook.arn}"
}

resource "aws_launch_configuration" "cluster" {
    name_prefix = "${var.name}"
    instance_type = "${var.instance_type}"
    image_id = "${data.aws_ami.coreos_stable.id}"
    iam_instance_profile = "${aws_iam_instance_profile.instance.name}"
    key_name = "${var.key_name}"
    user_data = "${data.template_file.cloud_config.rendered}"
    lifecycle = {
        create_before_destroy = true
    }
    security_groups = [
        "${module.ec2_security_group.id}"
    ]
}

resource "aws_iam_instance_profile" "instance" {
    name = "${var.name}-instance"
    roles = ["${aws_iam_role.instance.name}"]
}

resource "aws_iam_role" "instance" {
    name = "${var.name}-instance"
    assume_role_policy = "${data.aws_iam_policy_document.instance_assume_role.json}"
}

data "aws_iam_policy_document" "instance_assume_role" {
    statement {
        sid = ""
        effect = "Allow"
        principals {
            type = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
        actions = ["sts:AssumeRole"]
    }
}

resource "aws_iam_role_policy" "instance" {
    name = "${var.name}-instance"
    role = "${aws_iam_role.instance.name}"
    policy = "${data.aws_iam_policy_document.instance_role.json}"
}

data "aws_iam_policy_document" "instance_role" {
    statement {
        effect = "Allow"
        actions = [
            "kms:Decrypt",
            "kms:DescribeKey"
        ]
        resources = [
            "arn:aws:kms:${data.aws_region.selected.id}:${data.aws_caller_identity.current.account_id}:key/${var.kms_key_id}",
        ]
    }
    statement {
        sid = "AllowLoggingToCloudWatch"
        effect = "Allow"
        actions = [
            "logs:CreateLogStream",
            "logs:PutLogEvents",
        ]
        resources = [
            "arn:aws:logs:${data.aws_region.selected.id}:${data.aws_caller_identity.current.account_id}:log-group:${var.name}/*"
        ]
    }
}

resource "aws_cloudwatch_log_group" "default" {
    name = "${var.name}"
}
