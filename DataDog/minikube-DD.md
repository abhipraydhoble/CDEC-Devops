🚀 Steps to Monitor Minikube with Datadog
Enable Kubernetes Metrics Server
````
minikube addons enable metrics-server
````
Create a Kubernetes Secret with Datadog API Key
````
kubectl create secret generic datadog-secret \
  --from-literal api-key='<YOUR_DATADOG_API_KEY>'
````
Apply Datadog Agent Manifest
````
git clone https://github.com/DataDog/datadog-agent.git
cd datadog-agent/deploy/kubernetes
kubectl apply -f datadog-agent.yaml
````
