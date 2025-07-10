## Create EKS Cluster
#### launch one instance t2.medium


**1:Install eksctl CLI tool for creating EKS Clusters on AWS**
##### download eksctl CLI tool for creating EKS Clusters on AWS
```` 
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
````
##### move eksctl setup to /usr/local/bin directory

````
sudo mv /tmp/eksctl /usr/local/bin
```` 
##### To check eksctl version
```` 
eksctl version
````

**2:Install kubectl**
Download the latest release with the command:
````
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
````

Install kubectl:
````
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
````
Note:
If you do not have root access on the target system, you can still install kubectl to the ~/.local/bin directory:
````
chmod +x kubectl
mkdir -p ~/.local/bin
mv ./kubectl ~/.local/bin/kubectl
````
````
kubectl version --client
````

**3:Install AWS CLI on Ubuntu**
##### Download the aws cli bundle using below command
````
sudo apt install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
````


**4:Configure AWS CLI**
##### To connect AWS using CLI we have configure AWS user using below command
````
aws configure
````

**5:Create Amazon EKS cluster using eksctl**
````
eksctl create cluster --name my-ekscluster --region ap-southeast-1 --version 1.32 --nodegroup-name linux-nodes --node-type t2.medium--nodes 2
````
**6: Log In Into EKS cluster**
````
aws eks update-kubeconfig --name my-ekscluster
````
**7: Delete EKS Cluster**
````
eksctl delete cluster --name my-ekscluster --region ap-southeast-1
````
