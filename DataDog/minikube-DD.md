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
Add the Datadog Helm repository
````
helm repo add datadog https://helm.datadoghq.com
helm repo update

````
install agent
````
helm install datadog-agent datadog/datadog \
  --set datadog.apiKey=<YOUR_DATADOG_API_KEY> \
  --set datadog.site='datadoghq.com' \
  --set targetSystem=kubernetes \
  --set datadog.logs.enabled=true \
  --set datadog.apm.enabled=true \
  --set datadog.processAgent.enabled=true \
  --set daemonset.useHostPID=true \
  --namespace default
````
check pods
````
kubectl get pods
````
