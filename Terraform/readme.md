### $${\color{blue}\textbf{What is IAC}}$$

- Infrastructure as Code (IaC) means managing infrastructure using code instead of doing it manually.
- It saves time, reduces errors, and makes it easier for developers to focus on their work.
- Companies use IaC to save money, lower risks, and respond faster to new opportunities

### $${\color{blue}\textbf{How Infrastructure As A Code (IAC) Works}}$$

- IaC with Terraform and AWS means using code to manage AWS resources (like EC2, S3, etc.) instead of doing it manually.
- You write configuration files, store them in version control, and use Terraform to automatically create and manage your infrastructure.
- It makes your setup repeatable, consistent, and error-free.




### $${\color{blue}\textbf{How does Terraform work?}}$$

---

- Terraform creates and manages resources on cloud platforms and other services through their application programming interfaces (APIs).
- Providers enable Terraform to work with virtually any platform or service with an accessible API.
- HashiCorp and the Terraform community have already written thousands of providers to manage many different types of resources and services.
-  You can find all publicly available providers on the Terraform Registry, including Amazon Web Services (AWS), Azure, Google Cloud Platform (GCP), Kubernetes, 
   and many more

---
### Terraform vs. Ansible:

| Feature             | Terraform                            | Ansible                                |
|---------------------|--------------------------------------|----------------------------------------|
| **Purpose**          | Infrastructure provisioning          | Configuration management              |
| **State Management** | Uses state files to track changes    | No state management                   |
| **Language**         | HCL (HashiCorp Configuration Language) | YAML (Yet Another Markup Language)     |
| **Resource Management** | Manages infrastructure resources   | Manages software and configurations   |
| **Idempotency**      | Idempotent (does not create duplicates) | Idempotent (ensures consistent state) |
| **Use Case**         | Cloud resources (EC2, S3, etc.)      | Server configuration, apps, and services |

---

### Terraform vs. CloudFormation:

| Feature             | Terraform                            | CloudFormation                        |
|---------------------|--------------------------------------|---------------------------------------|
| **Provider Support** | Multi-cloud (AWS, Azure, GCP, etc.)  | AWS-only                              |
| **Language**         | HCL (HashiCorp Configuration Language) | JSON or YAML                          |
| **State Management** | Yes, uses state files                | No, manages state internally          |
| **Modularization**   | Supports modules                     | Limited modularization                |
| **Community**        | Strong open-source community         | AWS-specific, closed-source           |
| **Ease of Use**      | User-friendly, flexible              | AWS-centric, steeper learning curve   |


---

**AWS CLI Installation:**

````
sudo apt install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
````
````
aws --version
````
**Terraform Installation:Ubuntu**
````
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
````
````
terraform --version
````
**Set Up aws profile**
````
aws configure --profile "tf-user"
````

**add profile to provider.tf**
```tf
provider "aws {
 region = "ap-southeast-1"
 profile = "tf-user"
}
```

![image](https://github.com/user-attachments/assets/83c85698-f5b9-43b7-80fe-85ecb229cd8a)


