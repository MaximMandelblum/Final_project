
locals {
  cluster_name = "opsschool-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source = "git@github.com:MaximMandelblum/elephent_vpc.git"

  aws_region = "us-east-1"
  subnet1_public = ["10.0.1.0/24" , "10.0.50.0/24"]
  subnet2_private = ["10.0.100.0/24", "10.0.150.0/24"]
  vpc_name = "kalandula-vpc"
  cidr_network = "10.0.0.0/16"


}
