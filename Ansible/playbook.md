```yaml
- name: update and install and nginx
  hosts: all
  become: true

  tasks:
   
  - name: Upgrade all packages
    apt:
     name: '*'
     state: latest
      
  - name: Install the latest version of nginx
    apt:
     name: nginx
     state: latest
      
  - name: Start nginx
    service:
     name:  nginx
     state: started
     enabled: true
```

---
# updated
```yaml
- hosts: all
  become: yes
  tasks:

    - name: update
      apt: update_cache=yes

    - name: Install Nginx
      apt: name=nginx state=latest

      notify:
        - restart nginx

  handlers:
    - name: restart nginx
      service: name=nginx state=reloaded
````
