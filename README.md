## ![aws](https://github.com/odennav/terraform-k8s-aws_ec2/blob/main/icons-k8s-color/icons8-amazon-web-services-48.png)   AWS VPC 3-Tier Architecture with K8s Deployment    ![k8s](https://github.com/odennav/terraform-k8s-aws_ec2/blob/main/icons-k8s-color/icons8-kubernetes-48.png)

This project deploys a 3-Tier Architecture on AWS using Terraform, creating a VPC with private, public, and database subnets. Private EC2 instances communicate with the internet via a NAT gateway, and elastic IPs are assigned for NAT gateways. A public subnet is provided for a public EC2 instance, and an Internet Gateway facilitates communication for both private and public subnets.


## Special Credits

Special thanks to [Kubernetes-sigs](https://https://github.com/kubernetes-sigs) for their amazing work.


## Requirements

- **Minimum required version of Kubernetes is v1.27**
- **Ansible v2.14+, Jinja 2.11+ and python-netaddr is installed on the machine that will run Ansible commands**
- The target servers must have **access to the Internet** in order to pull docker images. Otherwise, additional configuration is required.
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
    terraform apply -auto-approve
    ```
Check AWS console for instances created and running

![ec2](https://github.com/odennav/terraform-k8s-aws_ec2/blob/main/ec2instances-shot.PNG)

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



## SSH Access
   Obtain a .pem terraform key from AWS, which is used to SSH into the public EC2 instance. .ppk key used for putty or windows.

   Use the obtained key pair to SSH into the public EC2 instance. This instance can serve as a jumpbox to access private EC2 instances.

   ```bash
   ssh -i private-key/terraform-key.pem ec2-user@<ipaddress>
   ```
   Its possible to use public EC2 instance as a jumpbox to securely SSH into private EC2 instances within the VPC.



## Destroying Resources(Optional)
To tear down the infrastructure created by Terraform.
  ```bash
  terraform destroy
  ```


Enjoy!
