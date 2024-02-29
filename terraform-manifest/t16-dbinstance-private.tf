# AWS EC2 Instance Terraform Module
# EC2 Instances that will be created in VPC Private Subnets
module "ec2_private_db" {
  depends_on = [ module.vpc ] # VERY VERY IMPORTANT else userdata webserver provisioning will fail
  source  = "terraform-aws-modules/ec2-instance/aws"
  #version = "2.17.0"
  version = "5.6.0"
  # insert the 10 required variables here
  #name                   = "${var.environment}-vm"
  #ami                    = data.aws_ami.amzlinux2.id
  ami                    = data.aws_ami.rhel9_3.id
  #ami                    = "ami-0fe630eb857a6ec83"
  instance_type          = var.instance_type
  key_name               = var.instance_keypair

  #user_data = file("${path.module}/install_arrival")
  
  tags = local.common_tags


# BELOW CODE COMMENTED AS PART OF MODULE UPGRADE TO 5.5.0
  #vpc_security_group_ids = [module.private_sg.this_security_group_id]    
  #instance_count         = var.private_instance_count
  #subnet_ids = [module.vpc.database_subnets[0],module.vpc.database_subnets[1] ]

# Changes as of Module version UPGRADE from 2.17.0 to 5.5.0
  vpc_security_group_ids = [module.private_sg.security_group_id]
  for_each = toset(["1", "2", "3"])
  subnet_id =  element(module.vpc.database_subnets, tonumber(each.key))

  name = "db-${each.key}"
}


# ELEMENT Function
# terraform console 
# element(["kalyan", "reddy", "daida"], 0)
# element(["kalyan", "reddy", "daida"], 1)
# element(["kalyan", "reddy", "daida"], 2)

