##  Provision AWS VPC & Deploy a Kubernetes Cluster  

This project uses terraform to deploy a 3-Tier Architecture on AWS which consists of the following:

- VPC

- Private, public and database subnets.

- Bastion, private and database EC2 instances.

- Internet and NAT gateway for all EC2 instances to communicate with the internet.

- Elastic IPs assigned for NAT gateways.

No routes created from NAT gateway to database instances.

Shell scripts used to automate deployment of kubernetes cluster to private EC2 instances with kubespray.

Inventory list for ansible is dynamically build with `.tpl` template.

EKS cluster is best for production but not deployed due to financial costs.

## Requirements

- Install [Terraform](https://developer.hashicorp.com/terraform/install)

- Install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

- Generate key pair for connection to EC2 instances in AWS console. Name it `terraform-key`. Choose `RSA` key pair type and use `.pem` key file format.

- Minimum required version of Kubernetes is **`v1.27`**

## Getting Started


Clone this repository to local machine
```bash
cd /
git clone git@github.com:odennav/terraform-aws-vpc-kubespray.git
cd terraform-kubernetes-aws-vpc-kubespray/terraform
```


Implement terraform commands sequentially in local machine to create the AWS infrastructure.

Initialize terraform working directory

```bash
terraform init
```

Validate the syntax of the terraform configuration files
```bash
terraform validate
```

Create an execution plan that describes the changes terraform will make to the infrastructure
```bash
terraform plan
```

Apply the changes described in execution plan
```bash
terraform apply -auto-approve
```
Check AWS console for instances created and running


![ec2](https://github.com/odennav/terraform-k8s-aws_ec2/blob/main/docs/ec2instances-shot.PNG)

-----
   
Use the `.pem` key from AWS to SSH into the public EC2 instance.

IPv4 address of public EC2 instance will be shown in terraform outputs.
```bash
ssh -i private-key/terraform-key.pem ec2-user@<ipaddress>
```
Its possible to use public EC2 instance as a jumpbox to ssh into private EC2 instances within the VPC.

Change root password upon first-Login to `control-dev` machine
```bash
sudo passwd
```

Switch to root user.

Add new user to sudo group. In this case new user is `odennav-admin`
```bash
sudo useradd odennav-admin
sudo usermod -aG wheel odennav-admin
```

Test sudo privileges by switching to new user
```bash
su - odennav-admin
sudo ls /root
```

You'll notice prompt to enter your user password.

To disable this prompt for every sudo command, implement the following:

Add sudoers file for `odennav-admin` user
```bash
cd /etc/sudoers.d/
sudo echo "odennav-admin ALL=(ALL) NOPASSWD: ALL" > odennav-admin
```
Set permissions for sudoers file
```bash
sudo chmod 0440 odennav-admin
```

Update yum package manager
```bash
sudo yum update -y
sudo yum upgrade -y
```

Confirm Git was installed by terraform
```bash
git --version
```

Confirm terraform-key was transferred to public EC2 instance by null provisioner
   
`terraform-key.pem` should be copied to another folder because it will be deleted if node is restarted or shutdown
```bash
ls -la /tmp/terraform-key.pem
cp /tmp/terraform-key.pem /
```

Change permissions of terraform-key.pem file
   
SSH test will fail if permissions of `.pem` key are not secure enough
```bash
sudo chmod 400 /tmp/terraform-key.pem
```


Clone this repository to `control-dev` node
```bash
cd /
git clone git@github.com:odennav/terraform-aws-vpc-kubespray.git
git clone git@github.com:kubernetes-sigs/kubespray.git
```

Copy IPv4 adresses of private EC2 instances deployed by Terraform
   
Check IPv4 addresses in `inventory` file and input them in `bash-scripts/ipaddr-list.txt`
   
Don't change format seen in `.txt` file, ip addresses will be read by the shell scripts.
   
For security reasons, don't share your private ips. 

-----

Install yum and python utilities

```bash
sudo chmod 770 dependencies-install
sudo ./dependencies-install
```

Setup nodes for Kubernetes cluster
    
```bash
sudo chmod 770 kubespray-deploy.sh
sudo ./kubespray-env-build.sh
```
   
Change directory to your local kubespray repository and execute the ansilbe playbook to deploy kubernetes cluster with kubespray
   
```bash
cd /kubespray
ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=odennav-admin cluster.yml
```

-----

#### Destroying Resources(Optional)

To tear down the infrastructure created by Terraform.

```bash
terraform destroy
```

-----

Enjoy!
