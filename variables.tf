variable "aws_region" {
  default = "us-east-1"
  type    = string
}

variable "ubuntu_account_number" {
  default = "099720109477"
}

variable "key_name" {
  default = "max_imperva"
  type = string
}


variable "instance_type" {
  description = "The type of the ec2, for example - t2.micro"
  type        = string
  default     = "t2.micro"
}

variable "private_key_path" {}

variable "consul_server" {
  description = " number of needed instances to build "
  type        = string
  default     = 3
}
variable "jenkins_server" {
  description = " number of needed jenkins servers to build "
  type        = string
  default     = 1
}
variable "jenkins_agent" {
  description = " number of needed jenkins agents to build "
  type        = string
  default     = 1
}

locals {
  k8s_service_account_namespace = "default"
  k8s_service_account_name      = "opsschool-sa"
}

