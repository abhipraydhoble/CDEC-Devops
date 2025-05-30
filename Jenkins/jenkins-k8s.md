
## Step - 1 : Create EKS Host in AWS #

1) Launch new Ubuntu VM using AWS Ec2 ( t2.micro )	  
2) Connect to machine and install kubectl using below commands  
```
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
kubectl version --short --client
```
3) Install AWS CLI latest version using below commands 
```
sudo apt install unzip 
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
```



4) Install eksctl using below commands
```
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
```

## Create IAM role & attach to EKS Host & Jenkins Server #

1) Create New Role using IAM service ( Select Usecase - ec2 ) 	
2) Add below permissions for the role <br/>
	- IAM - fullaccess <br/>
	- VPC - fullaccess <br/>
	- EC2 - fullaccess  <br/>
	- CloudFomration - fullaccess  <br/>
	- Administrator - acces <br/>
		
3) Enter Role Name (eksrole) 
4) Attach created role to EKS Management Host (Select EC2 => Click on Security => Modify IAM Role => attach IAM role we have created) 
5) Attach created role to Jenkins Machine (Select EC2 => Click on Security => Modify IAM Role => attach IAM role we have created) 
---

**Configure AWS CLI**
##### To connect AWS using CLI we have configure AWS user using below command
````
aws configure
````

## Step: Create EKS Cluster using eksctl # 

````
eksctl create cluster --name my-ekscluster --region ap-southeast-1 --version 1.32 --nodegroup-name linux-nodes --node-type t2.micro --nodes 2
````
**Log In Into EKS cluster**
````
aws eks update-kubeconfig --name my-ekscluster
````
**Delete EKS Cluster**
````
eksctl delete cluster --name my-ekscluster --region ap-southeast-1
````

Note:  After cluster created we can check nodes using below command.	
```
kubectl get nodes  
```

## Jenkins Server Setup in Linux VM #

Install Jenkins
````
sudo apt update -y
sudo apt install fontconfig openjdk-21-jre -y
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install jenkins -y
sudo systemctl start jenkins
sudo systemctl enable jenkins
````

Copy jenkins admin pswd
```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
	  

##  Setup Docker in Jenkins ##
```
curl -fsSL get.docker.com | /bin/bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
sudo docker version
```
## Install AWS CLI in JENKINS Server #  

**Install AWS CLI**
```
sudo apt install unzip 
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
```
 
##  Install Kubectl in JENKINS Server #


```
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
kubectl version --short --client
```

##  Update EKS Cluster Config File in Jenkins Server #
	
1) Execute below command in Eks Management host & copy kube config file data <br/>
	$ cat .kube/config 

2) Execute below commands in Jenkins Server and paste kube config file  <br/>
	$ cd /var/lib/jenkins <br/>
	$ sudo mkdir .kube  <br/>
	$ sudo vi .kube/config  <br/>

3) Execute below commands in Jenkins Server and paste kube config file for ubuntu user to check EKS Cluster info<br/>
	$ cd ~ <br/>
	$ ls -la  <br/>
	$ sudo vi .kube/config  <br/>

4) check eks nodes <br/>
	$ kubectl get nodes 

**Note: We should be able to see EKS cluster nodes here.**

