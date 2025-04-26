# Jenkins Installation
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
## sample pipeline

```pipeline
pipeline {
    agent any
    tools {
        maven 'maven'
    }
    
    stages{
        stage('code-pull'){
            steps {
                git branch: 'main', url: 'https://github.com/abhipraydhoble/Project-InsureMe.git'
            }
        }
        
        stage('code-build'){
            steps{
                sh "mvn clean package"
            }
        }

        stage('code-deploy'){
            steps{
                sh "docker build -t insureme ."
                sh "docker run -itd --name mycont -p 8089:8081 insureme"
            }
        }

    }
}
```
