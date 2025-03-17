## Namespace
- In Kubernetes, namespaces provide a mechanism for isolating groups of resources within a single cluster.

## create namespace using manifest
```yaml
apiVersion: v1
kind: Namespace
metadata:
 name: prod
```

````
kubectl apply -f ns.yaml
````

````
kubectl get ns
````
**Create Pod in specific namespace**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  namespace: prod
spec:
  containers:
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80
```
````
kubectl apply -f pod.yaml
````

## create namespace using commands

````
kubectl create ns <namespace-name>   eg. kubectl create ns dev
````

````
kubectl get ns
````
**set dev as default ns**
````
kubectl config set-context --current  --namespace=dev
````
**check current ns**
````
kubectl config view --minify | grep namespace:
````
````
kubectl config get-contexts
````
````
kubectl apply -f pod.yaml -n dev
````
````
kubectl get pod -n dev
````

````
kubectl get pods --all-namespaces
````
