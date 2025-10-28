## AWS CLI installation 
````
sudo apt install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
````


## Plugins Required
````
stage view
````
````
aws credentials
````
````
s3 publisher
````
````
maven integration
````
````
docker
````
**note: first 4 plugins of docker**

## manage jenkins-> tools
- maven
- docker

## manage jenkins-> credentials
- **aws credentials**
- access_key
- secret_key

## Pipeine
````
pipeline {
    agent any
    
   environment {
        S3_BUCKET = 'oncdec-b29-jen-s3-integration'
        AWS_REGION = 'ap-southeast-1'
        warFile = 'target/Insurance-0.0.1-SNAPSHOT.jar'
    }
    
    stages{
        stage('code-pull'){
            steps{
                git branch: 'main', url: 'https://github.com/abhipraydhoble/Project-InsureMe.git'
            }
        }
        
        stage('code-build'){
            steps{
                sh 'mvn clean package'
            }
        }
        
        stage('code-push'){
            steps{
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-cred', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                  sh "aws s3 cp ${warFile} s3://${S3_BUCKET}/artifacts/ --region ${AWS_REGION}"
              }
            }
        }
    }
}
````


## repository link
````
https://github.com/abhipraydhoble/Project-InsureMe.git
````
