resource "aws_security_group" "allow_ssh" {
    name = "kalandula_sg"
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
vpc_security_group_ids = [aws_security_group.allow_ssh.id]
user_data = file("scripts/consul-server.sh")
tags = {
Name = "Consul_server-${count.index + 1}"
}

}
