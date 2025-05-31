## launch two instances (ubuntu) 
## create ssh keypair
````
ssh-keygen
````

## copy public key And paste to worker node .ssh/authorized_keys file

**Install ansible on master node**
  

````
sudo apt-add-repository ppa:ansible/ansible
````
````
sudo apt update
````
````
sudo apt install ansible
````
````
ansible --version
````
### set up inventory file

````
sudo nano /etc/ansible/hosts
private-ip of worker nodes
````

### edit ansible.cfg

````
[defaults]
inventory = hosts
host_key_checking = False
````


### ping all nodes to test connection
````
ansible all -m ping
````
### run playbook
````
ansible-playbook nginx.yaml
````
