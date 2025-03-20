### POD
- It is the smallest fundamental component of kubernetes architecture
- Pod are the emphermeral[ short-lived, temporary]
- It is workload resource
- It contain single or multiple containers
### Concept of main container and side container
  1. Main container:
     - It is primary container in pod
     - It is responsible for handling core functionality of application
  3.  Sidecar container:
     - Container that run alongside the main container
     - It often handles the task like logging, mointoring, data transforming
### example:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
  labels:
    app: my-app
spec:
  containers:
  - name: my-container
    image: nginx:latest
    ports:
    - containerPort: 80
```
