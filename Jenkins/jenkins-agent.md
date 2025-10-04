## Set Up Jenkins Node

### Launch 2 ec2 instances
1. Jenkins Master
2. Jenkins Node

![image](https://github.com/user-attachments/assets/023522f6-dc67-49c7-9cfe-177104ae915b)

**Jenkins Master**
- Install Jenkins
- Generate ssh-key
  

**Jenkins Node**
- Create directory with name /jenkins
- give permission 777
- install java
````
  sudo apt install fontconfig openjdk-17-jre -y
````
- copy public key from jenkins-master and paste it to .ssh/authorized_key

**Jenkins Master**
  ![image](https://github.com/user-attachments/assets/8b360150-6690-4b34-bbb9-52848df414ff)

  ![image](https://github.com/user-attachments/assets/d2b103cf-c29e-4ef2-888e-e04601dacdf5)

**Jenkins Node Setup**

![image](https://github.com/user-attachments/assets/1a9793dc-cf9b-480d-81c2-7c2d1d582f79)

<img width="1382" height="550" alt="image" src="https://github.com/user-attachments/assets/3a58d3f5-b6af-4357-a833-986df2fae5b5" />

![image](https://github.com/user-attachments/assets/e62a3690-66a7-473f-940f-5bf5b615c031)

**Create Job**
![image](https://github.com/user-attachments/assets/0fb931af-108b-4a32-89d9-577148cfb9df)

**Check Output**
![image](https://github.com/user-attachments/assets/0bf8f6f3-7ad6-45c5-8124-fe1384211e7a)
