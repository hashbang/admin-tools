resource "aws_security_group" "sg" {
    name_prefix = "${var.name}-${var.vpc_id}-"
    description = " For ${var.name} in VPC ${var.vpc_id}"
    vpc_id = "${var.vpc_id}"
    tags {
        Name = "${var.name}-${var.vpc_id}"
    }
}

resource "aws_security_group_rule" "all_internal_ingress" {
    count = "${var.all_internal}"
    security_group_id = "${aws_security_group.sg.id}"
    type = "ingress"
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    self = true
}

resource "aws_security_group_rule" "all_internal_egress" {
    count = "${var.all_internal}"
    security_group_id = "${aws_security_group.sg.id}"
    type = "egress"
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    self = true
}

resource "aws_security_group_rule" "all_inbound_ssh" {
    count = "${var.all_inbound_ssh}"
    security_group_id = "${aws_security_group.sg.id}"
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "all_inbound_http" {
    count = "${var.all_inbound_http}"
    security_group_id = "${aws_security_group.sg.id}"
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "all_inbound_https" {
    count = "${var.all_inbound_https}"
    security_group_id = "${aws_security_group.sg.id}"
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "all_outbound" {
    count = "${var.all_outbound}"
    security_group_id = "${aws_security_group.sg.id}"
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "all_inbound" {
    count = "${var.all_inbound}"
    security_group_id = "${aws_security_group.sg.id}"
    type = "ingress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "group_inbound_nfs" {
    count = "${var.group_inbound_nfs}"
    security_group_id = "${aws_security_group.sg.id}"
    type = "ingress"
    from_port = 2049
    to_port = 2049
    protocol = "tcp"
    source_security_group_id = "${var.group_inbound_nfs_id}"
}

resource "aws_security_group_rule" "group_outbound_nfs" {
    count = "${var.group_outbound_nfs}"
    security_group_id = "${aws_security_group.sg.id}"
    type = "egress"
    from_port = 2049
    to_port = 2049
    protocol = "tcp"
    source_security_group_id = "${var.group_outbound_nfs_id}"
}
