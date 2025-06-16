# Create eks-server in AWS AWS Ec2 type ( t2.medium )
Connect to machine and install kubectl using below commands
```
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
kubectl version --short --client
```
# Install AWS CLI latest version using below commands
```
sudo apt install unzip 
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
```

# Install eksctl using below commands
```
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
```
Create IAM role & attach to eks-server & jenkins-server
Create New Role using aws IAM service ( Select Usecase - ec2 )

Add below permissions for the role

IAM - fullaccess
VPC - fullaccess
EC2 - fullaccess
CloudFomration - fullaccess
Administrator - acces
Enter Role Name (eksrole)

Attach created role to aws ec2 eks-server (Select EC2 => Click on Security => Modify IAM Role => attach IAM role we have created)

Attach created role to jenkins-server (Select EC2 => Click on Security => Modify IAM Role => attach IAM role we have created)
# Configure AWS CLI on eks-server
```
aws configure
```
# Step: Create EKS Cluster using eksctl
```
eksctl create cluster \
  --name my-ekscluster \
  --region <your-region-name> \
  --version 1.32 \
  --nodegroup-name linux-nodes \
  --node-type t2.micro \
  --nodes 2 \
  --ssh-access \
  --ssh-public-key <your-key-pair-name>
```

Log In Into EKS cluster
```
aws eks update-kubeconfig --name my-ekscluster
kubectl get nodes
```
Note: After cluster created we can check nodes using below command.
```
kubectl get nodes
```

# create jenkins-server on aws ec2 ubuntu machine (t2.micro)

Install Jenkins and java
```
sudo apt update
sudo apt install fontconfig openjdk-21-jre
java -version
```
```
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins
```
# Get jenkins password
```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
Setup Docker in Jenkins
```
curl -fsSL get.docker.com | /bin/bash
sudo usermod -aG docker jenkins
sudo usermod -aG docker $USER
sudo chmod 777 /var/run/docker.sock
sudo systemctl restart jenkins
sudo newgrp docker
sudo docker version
```
Install AWS CLI in JENKINS Server
Install AWS CLI
```
sudo apt install unzip 
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
```
Install Kubectl in JENKINS Server
```
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
kubectl version --short --client
```
# Update EKS Cluster Config File in jenkins-server
Execute below command in eks-server & copy kube config file data
```
cat .kube/config
```
Execute below commands in jenkins-server and paste kube config file
```
cd /var/lib/jenkins
sudo mkdir .kube
sudo vi .kube/config
```

check eks nodes
```
export KUBECONFIG=~/.kube/config
kubectl config current-context
kubectl get nodes
```
# check using jenkins pipeline 
1.install plugins:- stage,aws credential

2.create aws-cred in manage jenkins> credential

3.create pipeline
```
pipeline {
  agent any
  environment {
    KUBECONFIG = '/var/lib/jenkins/.kube/config'
  }
  stages {
    stage('Use AWS Credentials') {
      steps {
          withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-cred', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          sh "aws sts get-caller-identity"
          sh "kubectl get nodes"
            }
      }
    }
}
}
```

Note: We should be able to see EKS cluster nodes in jenkins console and jenkins server 
# Delete eks cluster after use in eks-server
```
eksctl delete cluster --name my-ekscluster --region <your-region-name>
```
