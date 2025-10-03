# SetUp Minikube First
# Deployment 1
````
kubectl create deployment web --image=gcr.io/google-samples/hello-app:1.0
````
# Service 1
````
kubectl expose deployment web --type=NodePort --port=8080
````
# Deployment 2
````
kubectl create deployment web2 --image=gcr.io/google-samples/hello-app:2.0 
````
# Service 2
````
kubectl expose deployment web2 --port=8080 --type=NodePort
````
# ingress.yaml
````
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
spec:
  ingressClassName: nginx
  rules:
    - host: hello-world.example
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: web
                port:
                  number: 8080
          - path: /v2
            pathType: Prefix
            backend:
              service:
                name: web2
                port:
                  number: 8080
````


# Test Ingress
````
curl --resolve "hello-world.example:80:$( minikube ip )" -i http://hello-world.example
````
