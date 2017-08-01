data "aws_region" "selected" {
    current = true
}

data "aws_caller_identity" "current" {}

data "aws_route53_zone" "selected" {
    name = "${replace(var.domain, "/^.*\\.([^\\.]+)\\.([^\\.]+)$/", "$1.$2.")}"
}

resource "aws_lambda_permission" "sns_instance_launch" {
    statement_id = "AllowExecutionFromSNS"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.asg_ip_attach.function_name}"
    principal = "sns.amazonaws.com"
    source_arn = "${var.launch_topic}"
}

resource "aws_lambda_permission" "sns_instance_terminate" {
    statement_id = "AllowExecutionFromSNS"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.asg_ip_detach.function_name}"
    principal = "sns.amazonaws.com"
    source_arn = "${var.terminate_topic}"
}

resource "aws_sns_topic_subscription" "asg_ip_attach" {
  topic_arn = "${var.launch_topic}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.asg_ip_attach.arn}"
}

resource "aws_sns_topic_subscription" "asg_ip_detach" {
  topic_arn = "${var.terminate_topic}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.asg_ip_detach.arn}"
}

resource "aws_lambda_function" "asg_ip_attach" {
    filename = "${data.archive_file.asg_ip_attach.output_path}"
    source_code_hash = "${data.archive_file.asg_ip_attach.output_base64sha256}"
    role = "${aws_iam_role.asg_ip_manage.arn}"
    timeout = "10"
    function_name = "${var.name}-asg_ip_attach"
    handler = "index.handler"
    runtime = "python2.7"
    environment {
        variables = {
            domain = "${var.domain}",
            hosted_zone = "${data.aws_route53_zone.selected.id}",
            asg = "${var.asg}",
            region = "${data.aws_region.selected.id}"
        }
    }
}

resource "aws_lambda_function" "asg_ip_detach" {
    filename = "${data.archive_file.asg_ip_detach.output_path}"
    source_code_hash = "${data.archive_file.asg_ip_detach.output_base64sha256}"
    role = "${aws_iam_role.asg_ip_manage.arn}"
    timeout = "10"
    function_name = "${var.name}-asg_ip_detach"
    handler = "index.handler"
    runtime = "python2.7"
    environment {
        variables = {
            domain = "${var.domain}",
            hosted_zone = "${data.aws_route53_zone.selected.id}",
            asg = "${var.asg}",
            region = "${data.aws_region.selected.id}"
        }
    }
}

data "archive_file" "asg_ip_attach" {
    type = "zip"
    source_dir = "${path.module}/lambda/asg_ip_attach/"
    output_path = "${path.module}/.terraform/archive/lambda_asg_ip_attach.zip"
}

data "archive_file" "asg_ip_detach" {
    type = "zip"
    source_dir = "${path.module}/lambda/asg_ip_detach/"
    output_path = "${path.module}/.terraform/archive/lambda_asg_ip_detach.zip"
}

resource "aws_iam_role_policy" "asg_ip_manage" {
    name = "${var.name}-lambda-asg-ip-manage"
    role = "${aws_iam_role.asg_ip_manage.id}"
    policy = "${data.aws_iam_policy_document.asg_ip_manage_role_policy.json}"
}
data "aws_iam_policy_document" "asg_ip_manage_role_policy" {
    statement {
        effect = "Allow"
        actions = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
        ]
        resources = ["arn:aws:logs:${data.aws_region.selected.id}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*"]
    }
    statement {
        effect = "Allow"
        actions = [
            "ec2:DescribeInstances",
        ]
        resources = ["*"]
    }
    statement {
        effect = "Allow"
        actions = [
            "route53:ChangeResourceRecordSets"
        ]
        resources = ["arn:aws:route53:::hostedzone/${data.aws_route53_zone.selected.id}"]
    }
    statement {
        effect = "Allow"
        actions = [
            "route53:GetChange",
        ]
        resources = ["arn:aws:route53:::change/*"]
    }
}

resource "aws_iam_role" "asg_ip_manage" {
    name = "${var.name}-lambda-asg-ip-manage"
    assume_role_policy = "${data.aws_iam_policy_document.asg_ip_manage_role.json}"
}

data "aws_iam_policy_document" "asg_ip_manage_role" {
    statement {
        sid = ""
        effect = "Allow"
        principals {
            type = "Service"
            identifiers = ["lambda.amazonaws.com"]
        }
        actions = ["sts:AssumeRole"]
    }
}

