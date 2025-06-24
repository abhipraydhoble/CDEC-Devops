

# HPA with Minikube

#  make sure your minikube cluster is running

# enable metrics-server
````
minikube addons enable metrics-server
````

# create deployment 
````
vim hpa-dep.yaml
````

````
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hpa-nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hpa-nginx
  template:
    metadata:
      labels:
        app: hpa-nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        resources:
          requests:
            cpu: "100m"
          limits:
            cpu: "200m"
        ports:
        - containerPort: 80
````
````
kubectl apply -f hpa-dep.yaml
````

---
# create service.yaml
````
apiVersion: v1
kind: Service
metadata:
  name: hpa-service
spec:
  selector:
    app: hpa-nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: ClusterIP
````
````
kubectl apply -f  service.yaml
````

# create hpa.yaml


````
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: hpa-nginx
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: hpa-nginx
  minReplicas: 1
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
````
````
kubectl apply -f hpa.yaml
````

# Generate Load
````
kubectl run -i --tty load-generator --image=busybox /bin/sh
````
*note:* - run below command in shell

````
while true; do wget -q -O- http://hpa-service; done
````
# check
````
kubectl get hpa -w
kubectl get pods
````
