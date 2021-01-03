resource "aws_security_group" "consul_sg" {
    name = "consul_sg"
    description = "allows project ssh"
    vpc_id = module.vpc.vpc_id

    ingress  {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress  {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 8500
        to_port     = 8500
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow consul UI access from the world"
    }
    egress  {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

}

resource "aws_security_group" "jenkins_sg" {
    name = "jenkins_sg"
    description = "allows project ssh"
    vpc_id = module.vpc.vpc_id

    ingress  {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["80.179.69.192/26"]
    }
    ingress  {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["80.179.69.192/26"]
    }
    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["80.179.69.192/26"]
        description = "Allow consul UI access from the world"
    }
   ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["80.179.69.192/26"]
        description = "Allow consul UI access from the world"
    }
    egress  {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

}

# Create an IAM role for the auto-join
resource "aws_iam_role" "consul-join" {
  name               = "consul-join-role"
  assume_role_policy = file("${path.module}/templates/policies/assume-role.json")
}

# Create the policy
resource "aws_iam_policy" "consul-join" {
  name        = "consul-join-policy"
  description = "Allows Consul nodes to describe instances for joining."
  policy      = file("${path.module}/templates/policies/describe-instances.json")
}

# Attach the policy
resource "aws_iam_policy_attachment" "consul-join" {
  name       = "consul-join-policy-attach"
  roles      = [aws_iam_role.consul-join.name]
  policy_arn = aws_iam_policy.consul-join.arn
}

# Create the instance profile
resource "aws_iam_instance_profile" "consul-join" {
  name  = "consul-join-profile"
  role = aws_iam_role.consul-join.name
}

##########################################
### INSTANCES Consule Server ###
##########################################

resource "aws_instance" "consul_server" {
count = var.consul_server
ami = data.aws_ami.ubuntu-18.id
instance_type = "t2.micro"
key_name = var.key_name
subnet_id = element(module.vpc.public_subnet_ids, count.index )
associate_public_ip_address = true
vpc_security_group_ids = [aws_security_group.consul_sg.id]
user_data = file("scripts/consul-server.sh")
tags = {
Name = "Consul_server-${count.index + 1}"
}

}

##########################################
### INSTANCES Jenkins Server ###
##########################################

resource "aws_instance" "jenkins_server" {
count = var.jenkins_server
ami = data.aws_ami.ubuntu-18.id
instance_type = "t3.micro"
key_name = var.key_name
subnet_id = element(module.vpc.public_subnet_ids, count.index )
associate_public_ip_address = true
vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
#user_data = file("scripts/consul-server.sh")
tags = {
Name = "Jenkins_server-${count.index + 1}"
}

}

##########################################
### INSTANCES Jenkins Agent ###
##########################################

resource "aws_instance" "jenkins_agent" {
count = var.jenkins_agent
ami = data.aws_ami.ubuntu-18.id
instance_type = "t2.micro"
key_name = var.key_name
subnet_id = element(module.vpc.private_subnet_ids, count.index )
associate_public_ip_address = true
vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
#user_data = file("scripts/consul-server.sh")
tags = {
Name = "Jenkins_agent-${count.index + 1}"
}

}
