variable "domain" {}
variable "name" {}
variable "asg" {}
variable "health_type" { default = "HTTP" }
variable "health_port" { default = "443" }
variable "health_path" { default = "/" }
variable "launch_topic" { default = "" }
variable "terminate_topic" { default = "" }
