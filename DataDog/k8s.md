````
kubectl create secret generic datadog-secret \
  --from-literal api-key='<YOUR_DATADOG_API_KEY>'
````
or
````
apiVersion: v1
kind: Secret
metadata:
  name: datadog-secret
  namespace: default
type: Opaque
stringData:
  api-key: "6ae657e64f887707264884fb77d66199"

````

# damonset

````
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: datadog-agent
  namespace: default
  labels:
    app: datadog-agent
spec:
  selector:
    matchLabels:
      app: datadog-agent
  template:
    metadata:
      labels:
        app: datadog-agent
    spec:
      serviceAccountName: datadog-agent
      containers:
        - name: agent
          image: "gcr.io/datadoghq/agent:latest"
          env:
            - name: DD_API_KEY
              valueFrom:
                secretKeyRef:
                  name: datadog-secret
                  key: api-key
            - name: DD_SITE
              value: "datadoghq.com"
            - name: DD_LOGS_ENABLED
              value: "true"
            - name: DD_LOGS_CONFIG_CONTAINER_COLLECT_ALL
              value: "true"
            - name: DD_APM_ENABLED
              value: "true"
          resources:
            limits:
              memory: "256Mi"
              cpu: "200m"
          volumeMounts:
            - name: dockersocket
              mountPath: /var/run/docker.sock
            - name: proc
              mountPath: /host/proc
              readOnly: true
            - name: cgroups
              mountPath: /host/sys/fs/cgroup
              readOnly: true
      volumes:
        - name: dockersocket
          hostPath:
            path: /var/run/docker.sock
        - name: proc
          hostPath:
            path: /proc
        - name: cgroups
          hostPath:
            path: /sys/fs/cgroup
````

````
apiVersion: v1
kind: ServiceAccount
metadata:
  name: datadog-agent
````

