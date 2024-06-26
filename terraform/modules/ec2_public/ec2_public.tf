terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

}

# AWS EC2 Instance Terraform Module
# Bastion Host - EC2 Instance that will be created in VPC Public Subnet
module "ec2_public" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.0"
  
  name                   = "${var.environment}-Control"
  ami                    = data.aws_ami.rhel9_3.id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  subnet_id              = module.vpc.public_subnets[0]
  user_data = file("${path.module}/arrival_install")
  vpc_security_group_ids = [module.public_bastion_sg.security_group_id]
  tags = local.common_tags
  
}

