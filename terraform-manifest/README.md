## Overview of Terraform Files

#### t1-versions.tf: 
- Specifies the required Terraform version and the AWS provider version.

#### t2-generic-variables.tf:
- Defines input variables such as the AWS region, environment, and business division.

#### t3-local-values.tf:
- Specifies local values used in Terraform, including owners, environment, and name.

#### t4-vpc-variables.tf:
- Utilizes input variables to provision VPC with specified configurations.

#### t5-vpc-module.tf:
- Defines a Terraform module to create the VPC with configurable parameters like VPC name, CIDR blocks, availability zones, and subnets.

#### t6-vpc-outputs.tf:
- Outputs VPC-related information such as VPC ID, CIDR blocks, subnets, NAT gateway IPs, and availability zones.

#### t8-securitygroup-outputs.tf:
- Outputs security group information for public bastion hosts and private EC2 instances.

#### t9-securitygroup-bastionsg.tf:
- Creates a security group for the public bastion host.

#### t10-securitygroup-privatesg.tf:
- Creates a security group for private EC2 instances.

#### t11-datasource-ami.tf:
- Retrieves the latest Amazon Linux 2 AMI ID.

#### t12-ec2instance-variables.tf:
- Defines variables for EC2 instances, including type, key pair, and instance count.

#### t13-ec2instance-outputs.tf:
- Outputs information about public and private EC2 instances. Insert ip addresses for private ec2instances into ipaddr-list.txt.
list of IPs used by bash scripts for kubernetes deployment.

#### t14-ec2instance-bastion.tf:
- Creates an EC2 instance for the public bastion host.

#### t15-ec2instnce-private.tf:
- Creates EC2 instances for the private subnet with count specified.

#### t16-dbinstance-private.tf:
- Creates EC2 instances for the database subnet with count specified.

#### t17-elasticip.tf:
- Creates an Elastic IP for the bastion host.

