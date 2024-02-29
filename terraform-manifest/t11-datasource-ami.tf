#Get latest AMI ID for Amazon Linux2 OS
#Define the RHEL 9.3 AMI by:
#RedHat, Latest, x86_64, EBS, HVM, RHEL 9.3
data "aws_ami" "rhel9_3" {
  most_recent = true

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["RHEL-9.3*"]
  }
}







