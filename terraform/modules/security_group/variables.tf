variable "name" {
    description = "Unique name of group"
}

variable "vpc_id" {
    description = "ID of VPC to create security groups in"
}

variable "all_internal" { default = false }
variable "all_inbound" { default = false }
variable "all_outbound" { default = false }
variable "all_inbound_ssh" { default = false }
variable "all_inbound_http" { default = false }
variable "all_inbound_https" { default = false }
variable "group_inbound_nfs" { default = false }
variable "group_inbound_nfs_id" { default = "" }
variable "group_outbound_nfs" { default = false }
variable "group_outbound_nfs_id" { default = "" }
