provider "aws" {
  profile = "imperva"
  region     = var.aws_region
}


terraform {
  required_version = "0.14.1"
}

variable "kubernetes_version" {
  default = 1.18
  description = "kubernetes version"
}
