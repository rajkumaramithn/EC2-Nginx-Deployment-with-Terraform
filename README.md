
# EC2 Nginx Deployment with Terraform

## 1. Project Overview

This project demonstrates Infrastructure as Code (IaC) using Terraform to deploy an Ubuntu 20.04 LTS EC2 instance on AWS with the Nginx web server.

The configuration automatically installs Nginx and replaces the default webpage with a custom HTML page:

"Welcome to the Terraform-managed Nginx Server on Ubuntu"

## 2. Technologies Used

- Amazon Web Services (AWS)
- Terraform
- Amazon EC2
- Ubuntu 20.04 LTS
- Nginx
- Bash and HTML

## 3. Project Structure

```text
terraform-nginx-ubuntu/
├── main.tf
├── variables.tf
├── outputs.tf
├── .gitignore
└── README.md
```

![Project structure Initially](Screenshots/SKT3-1.png)

## 4. AWS Resources

Terraform manages the following resources:

- **EC2 Instance:** A t2.micro instance running Ubuntu 20.04 LTS.
- **Security Group:** Allows HTTP traffic on port 80 and SSH traffic on port 22.
- **User Data:** Installs Nginx and configures the custom HTML webpage.
- **Terraform Outputs:** Displays the public IPv4 address and website URL.

The configuration uses the existing default VPC and its subnet. It does not create a separate VPC, subnet, or internet gateway.

## 5. Prerequisites

- An AWS account with permissions to manage EC2 and security groups.
- Terraform CLI installed.
- AWS CLI installed and configured.
- Visual Studio Code or another text editor.

Configure AWS credentials using:

```powershell
aws configure
```

Verify access using:

```powershell
aws sts get-caller-identity
```

## 6. Configuration

Follow the project structure and create the .tf files :

---

main.tf ( Refer to the file included for the full code )

![main.tf configuration](Screenshots/SKT3-2.png)


Note: this version of the deployment uses the existing VPC and Security Groups and Internet Gateway , however a version where all resources are seperately configured is also given in alternatemain.tf , refer to this file for the alternate version.

---

outputs.tf ( Refer to the file included for the full code )

![outputs.tf configuration](Screenshots/SKT3-3.png)

---

outputs.tf ( Refer to the file included for the full code )

![variables.tf configuration](Screenshots/SKT3-4.png)

For SSH, replace the example CIDR with your own public IP followed by `/32`.

---

## 7. Deployment Instructions

Open a terminal in the project directory.

### Initialize Terraform

```powershell
terraform init
```

![Terraform init](Screenshots/SKT3-5.png)

### Validate the configuration

```powershell
terraform validate
```

![Terraform validate](Screenshots/SKT3-6.png)

### Review the execution plan

```powershell
terraform plan
```

![Terraform plan 1](Screenshots/SKT3-7.png)
![Terraform plan 2](Screenshots/SKT3-8.png)
![Terraform plan 3](Screenshots/SKT3-9.png)
![Terraform plan 4](Screenshots/SKT3-10.png)

### Deploy the infrastructure

```powershell
terraform apply
```

![Terraform apply](Screenshots/SKT3-11.png)

Enter `yes` when prompted.

![Terraform apply yes](Screenshots/SKT3-12.png)

Terraform creates the EC2 instance and security group and displays the public IP and website URL.

![Terraform apply results](Screenshots/SKT3-13.png)

---

## 8. Access the Nginx Webpage

Copy the `nginx_url` value from the Terraform output and open it in a web browser.

Expected webpage content:

**Welcome to the Terraform-managed Nginx Server on Ubuntu**

![niginx url working on the browser](Screenshots/SKT3-14.png)

---

## 9. Visual representation of the AWS resources created by Terraform on the AWS Console

**EC2 Instance**

![EC2 instance on AWS Console](Screenshots/SKT3-15.png)

**EC2 Security Tab**

![EC2 instance security tab](Screenshots/SKT3-16.png)

**EC2 Tags Tab**

![EC2 instance Tags tab](Screenshots/SKT3-17.png)

**Security Group Overview with Inbound & Outboud Rules**

![Security Group Overview 1](Screenshots/SKT3-18.png)

![Security Group Overview 2](Screenshots/SKT3-19.png)

![Security Group Overview 3](Screenshots/SKT3-20.png)

---

## 10. Cleanup

To remove the resources created by this project, run:

```powershell
terraform destroy
```

![Terraform Destroy Command](Screenshots/SKT3-21.png)

Enter `yes` when prompted.

![Terraform Destroy Command yes](Screenshots/SKT3-22.png)

Verify that Terraform reports that the resources were destroyed.

![Terraform Destroy Command Results 1](Screenshots/SKT3-23.png)

![Terraform Destroy Command Results 2](Screenshots/SKT3-24.png)

---

## 11.Final Project Folder Structure to Expect

In this deployment, we use gitignore to make sure that some of the terraform file containing critical credentials are not included in the git uploads.
This is followed as per best security practices.

![Final Folder Structure](Screenshots/SKT3-25.png)

---

## 11. Conclusion

This project demonstrates how Terraform can automate AWS infrastructure provisioning using Infrastructure as Code principles. It provisions an Ubuntu EC2 instance, configures a security group, installs Nginx through user data, serves a custom webpage, outputs the public IP address, and removes the managed infrastructure through Terraform destroy.

---