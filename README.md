# ![aws](https://github.com/odennav/terraform-k8s-aws_ec2/blob/main/icons-k8s-color/icons8-amazon-web-services-96.png)AWS VPC 3-Tier Architecture with Kubernetes Deployment ![k8s](https://github.com/odennav/terraform-k8s-aws_ec2/blob/main/icons-k8s-color/icons8-kubernetes-48.png)

This project deploys a 3-Tier Architecture on AWS using Terraform, creating a VPC with private, public, and database subnets. Private EC2 instances communicate with the internet via a NAT gateway, and elastic IPs are assigned for NAT gateways. A public subnet is provided for a public EC2 instance, and an Internet Gateway facilitates communication for both private and public subnets.


## Special Credits

Special thanks to [Kubernetes-sigs](https://https://github.com/kubernetes-sigs) for their amaziing work.


## Requirements

- **Minimum required version of Kubernetes is v1.27**
- **Ansible v2.14+, Jinja 2.11+ and python-netaddr is installed on the machine that will run Ansible commands**
- The target servers must have **access to the Internet** in order to pull docker images. Otherwise, additional configuration is required (See [Offline Environment](docs/offline-environment.md))
- The target servers are configured to allow **IPv4 forwarding**.
- If using IPv6 for pods and services, the target servers are configured to allow **IPv6 forwarding**.
- The **firewalls are not managed**, you'll need to implement your own rules the way you used to.
    in order to avoid any issue during deployment you should disable your firewall.
- If kubespray is run from non-root user account, correct privilege escalation method
    should be configured in the target servers. Then the ansible_become flag
    or command parameters --become or -b should be specified.

Hardware:
These limits are safeguarded by Kubespray. Actual requirements for your workload can differ. For a sizing guide go to the [Building Large Clusters](https://kubernetes.io/docs/setup/cluster-large/#size-of-master-and-master-components) guide.

- Master
  - Memory: 1500 MB
- Node
  - Memory: 1024 MB


## Getting Started
1. **Execute these terraform commands sequentially on your local machine to create the AWS infrastructure.**
     ```bash
     cd terraform-manifest
     ```

   **Initializes terraform working directory**
    ```bash
    terraform init
    ```

   **Validate the syntax of the terraform configuration files**
     ```bash
     terraform validate
     ```

   **Create an execution plan that describes the changes terraform will make to the infrastructure.**
    ```bash
    terraform plan
    ```

   **Apply the changes described in execution plan**
    ```bash
    terraform destroy -auto-approve
    ```


2. Run dependencies-install.sh in public ec2instance to install necessary dependencies.
    ```bash
    chmod 770 dependencies-install
    bash dependencies-install
    ```
    Updating Yum, installing necessary dependencies, and ensuring Python compatibility.


3. Run kubespray-deploy.sh to deploy Kubernetes on the created infrastructure using kubespray.
   ```bash
   chmod 770 kubespray-deploy.sh
   bash kubespray-deploy.sh
   ```
   It creates a virtual environment, copies SSH keys, updates Ansible inventory, edits host inventory, installs kubectl and deploys Kubernetes cluster.
   Python script  builds inventory.
   Ansible playbook used to deploy kubernetes cluster.



## Overview of Terraform Files

#### t1-versions.tf:
Specifies the required Terraform version and the AWS provider version.

#### t2-generic-variables.tf:
Defines input variables such as the AWS region, environment, and business division.

#### t3-local-values.tf:
Specifies local values used in Terraform, including owners, environment, and name.

#### t4-vpc-variables.tf:
Utilizes input variables to provision VPC with specified configurations.

#### t5-vpc-module.tf:
Defines a Terraform module to create the VPC with configurable parameters like VPC name, CIDR blocks, availability zones, and subnets.

#### t6-vpc-outputs.tf:
Outputs VPC-related information such as VPC ID, CIDR blocks, subnets, NAT gateway IPs, and availability zones.

#### t8-securitygroup-outputs.tf:
Outputs security group information for public bastion hosts and private EC2 instances.

#### t9-securitygroup-bastionsg.tf:
Creates a security group for the public bastion host.

#### t10-securitygroup-privatesg.tf:
Creates a security group for private EC2 instances.

#### t11-datasource-ami.tf:
Retrieves the latest Amazon Linux 2 AMI ID.

#### t12-ec2instance-variables.tf:
Defines variables for EC2 instances, including type, key pair, and instance count.

#### t13-ec2instance-outputs.tf:
Outputs information about public and private EC2 instances. Insert ip addresses for private ec2instances into ipaddr-list.txt.
list of IPs used by bash scripts for kubernetes deployment.

#### t14-ec2instance-bastion.tf:
Creates an EC2 instance for the public bastion host.

#### t15-ec2instnce-private.tf:
Creates EC2 instances for the private subnet with count specified.

#### t16-dbinstance-private.tf:
Creates EC2 instances for the database subnet with count specified.

#### t17-elasticip.tf:
Creates an Elastic IP for the bastion host.



## SSH Access
   Obtain a .pem terraform key from AWS, which is used to SSH into the public EC2 instance. .ppk key used for putty or windows.

   Use the obtained key pair to SSH into the public EC2 instance. This instance can serve as a jumpbox to access private EC2 instances.

   ```bash
   ssh -i private-key/terraform-key.pem <ipaddress>
   ```
   Its possible to use public EC2 instance as a jumpbox to securely SSH into private EC2 instances within the VPC.



## Destroying Resources(Optional)
To tear down the infrastructure created by Terraform.
  ```bash
  terraform destroy
  ```


Enjoy!
