## ![aws](https://github.com/odennav/terraform-k8s-aws_ec2/blob/main/icons-k8s-color/icons8-amazon-web-services-48.png)   AWS VPC 3-Tier Architecture with K8s Deployment    ![k8s](https://github.com/odennav/terraform-k8s-aws_ec2/blob/main/icons-k8s-color/icons8-kubernetes-48.png)

This project deploys a 3-Tier Architecture on AWS using Terraform, creating a VPC with private, public,database subnets.
Bastion, private and database EC2 instances created for VPC.

NAT gateway created for private EC2 instances to communicate with the internet and elastic IPs are assigned for NAT gateways.
No routes created from NAT gateway to database instances.

Bash scripts used to automate deployment of kubernetes cluster to private EC2 instances with kubespray.


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
1. **Change password of public ec2instance (control-dev) user**
   ```bash
   sudo passwd
   ```

2. **Change directory to /**
   ```bash
   cd /
   ```

3. **Update yum package manager**
   ```bash
   yum update
   ```

4. **Confirm git was installed by terraform**
   ```bash
   git --version
   ```

5. **Confirm terraform-key was transferred to public ec2instance by null provisioner**
   Please note if .pem key not found, copy it manually. Also key can be copied to another folder because it will be deleted if node is restarted or shutdown
   ```bash
   ls -la /tmp/terraform-key.pem
   cp /tmp/terraform-key.pem /
   ```
   
6. **Change permissions of terraform-key.pem file**
   ssh test will fail if permissions of .pem key are not secure enough
   ```bash
   chmod 400 /tmp/terraform-key.pem
   ```

7. **Clone this repo to / directory in control-dev node**
   ```bash
   git clone git@github.com:odennav/terraform-k8s-aws_vpc.git
   ```

8. **Copy ip adresses of private ec2instances deployed by terraform**
   
   Enter each ip address into ipaddr-list.txt.
   Don't change format seen in .txt file
   Ip addresses will be read by bash scripts.
   For security reasons, don't show your private ips. The ones below are destroyed.
   Picture shown below is just for clarity.
   
   ![](https://github.com/odennav/terraform-k8s-aws_ec2/blob/main/ec2-private-ip.PNG) 
  

9. **Clone kubernetes-sigs kubespray repo to / directory in control node**
   ```bash
   git clone git@github.com:kubernetes-sigs/kubespray.git
   ```

10. **Execute these terraform commands sequentially on your local machine to create the AWS infrastructure.**
    
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

11. Run dependencies-install.sh in public ec2instance to install necessary dependencies.
    ```bash
    chmod 770 dependencies-install
    bash dependencies-install
    ```
    Updating Yum, installing necessary dependencies, and ensuring Python compatibility.


12. Run kubespray-deploy.sh to deploy Kubernetes on the created infrastructure using kubespray.
    ```bash
    chmod 770 kubespray-deploy.sh
    bash kubespray-deploy.sh
    ```
    Execution of this basch script creates a virtual environment, copies SSH keys, updates Ansible inventory, edits host inventory, installs kubectl and deploys Kubernetes cluster.
   Python script builds inventory.
   Ansible playbook used to deploy kubernetes cluster.



## SSH Access
   Obtain a .pem terraform key from AWS, which is used to SSH into the public EC2 instance. .ppk key used for putty or windows.

   Use the obtained key pair to SSH into the public EC2 instance. This instance can serve as a jumpbox to access private EC2 instances.

   ```bash
   ssh -i private-key/terraform-key.pem ec2-user@<ipaddress>
   ```
   Its possible to use public EC2 instance as a jumpbox to securely SSH into private EC2 instances within the VPC.



## Destroying Resources(Optional)
To tear down the infrastructure created by Terraform. Reduce costs incurred from AWS due to creation of resources.
  ```bash
  terraform destroy
  ```


Enjoy!
