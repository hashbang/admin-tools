output "name" {
    value = "${var.name}"
}

output "id" {
    value = "${aws_autoscaling_group.cluster.id}"
}

output "efs_id" {
    value = "${aws_efs_file_system.shared.id}"
}

output "instances_max" {
    value = "${var.instances_max}"
}

output "instances_min" {
    value = "${var.instances_min}"
}

output "launch_topic" {
    value = "${aws_sns_topic.instance_launch.id}"
}

output "terminate_topic" {
    value = "${aws_sns_topic.instance_terminate.id}"
}
