## 🧭 1. Prerequisites

- A running Kubernetes cluster on AWS (e.g., via EKS, Kops, or kubeadm).
- kubectl configured to access the cluster.
- IAM permissions to create and manage EBS volumes.
- aws-ebs-csi-driver installed.

## 📦 2. Install the AWS EBS CSI Driver

- The EBS CSI driver allows Kubernetes to provision EBS volumes dynamically.

- If using EKS, you can install it with:
````
eksctl utils associate-iam-oidc-provider --region <your-region> --cluster <your-cluster> --approve

````
- eksctl utils associate-iam-oidc-provider --region <your-region> --cluster <your-cluster> --approve
````
eksctl create iamserviceaccount \
  --region <your-region> \
  --name ebs-csi-controller-sa \
  --namespace kube-system \
  --cluster <your-cluster> \
  --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
  --approve
````

- Enable the driver:
````
eksctl create addon --name aws-ebs-csi-driver --cluster <your-cluster> --service-account-role-arn arn:aws:iam::<account-id>:role/<role-name> --region <your-region>
````


- Alternatively, you can install manually using Helm:
````
helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
helm repo update
helm install aws-ebs-csi-driver aws-ebs-csi-driver/aws-ebs-csi-driver \
  --namespace kube-system \
  --set enableVolumeResizing=true \
  --set enableVolumeSnapshot=true
````

## 🪣 Step 1: Create a StorageClass (storageclass-ebs.yaml)
````
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: ebs-sc
provisioner: ebs.csi.aws.com
volumeBindingMode: WaitForFirstConsumer
reclaimPolicy: Delete
parameters:
  type: gp3
  fsType: ext4
````

## 📦 Step 2: Create a PVC (pvc-student.yaml)
````
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: student-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: ebs-sc
  resources:
    requests:
      storage: 5Gi
````

## 🚀 Step 3: Update Your Deployment (student-deployment.yaml)
````
apiVersion: apps/v1
kind: Deployment
metadata:
  name: student-dep
spec:
  replicas: 5
  selector:
    matchLabels:
      app: studentapp
  template:
    metadata:
      name: tmp-01
      labels:
        app: studentapp
    spec:
      containers:
        - name: cont-1
          image: abhipraydh96/studentapp:v1
          ports:
            - containerPort: 80
          volumeMounts:
            - name: student-storage
              mountPath: /data   # your app can read/write here
      volumes:
        - name: student-storage
          persistentVolumeClaim:
            claimName: student-pvc
````
## 🧪 Step 4: Deploy Everything
````
kubectl apply -f storageclass-ebs.yaml
kubectl apply -f pvc-student.yaml
kubectl apply -f student-deployment.yaml
````
---


### 1️⃣ EBS CSI Driver installed


```bash
kubectl get csidriver
```

You should see:

```text
ebs.csi.aws.com
```

If not → install via EKS addon:

```bash
aws eks create-addon \
  --cluster-name <cluster-name> \
  --addon-name aws-ebs-csi-driver
```

---

### 2️⃣ IAM Role for EBS CSI (IRSA)

Your worker nodes or service account must have:

```
AmazonEBSCSIDriverPolicy
```

(Without this → PVC will stay **Pending**)

---

## 🧱 Create StorageClass for EKS (gp3 – Recommended)

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: ebs-gp3
provisioner: ebs.csi.aws.com
parameters:
  type: gp3
  fsType: ext4
volumeBindingMode: WaitForFirstConsumer
reclaimPolicy: Delete
allowVolumeExpansion: true
```

### Apply:

```bash
kubectl apply -f storageclass.yaml
```

---

## 🧠 Why These Settings Matter

| Field                  | Why                          |
| ---------------------- | ---------------------------- |
| `ebs.csi.aws.com`      | Uses AWS EBS CSI driver      |
| `gp3`                  | Cheaper + better than gp2    |
| `WaitForFirstConsumer` | Correct AZ placement         |
| `Delete`               | Auto-clean EBS on PVC delete |
| `allowVolumeExpansion` | Resize without downtime      |


---

## 🔹 Make It Default (Optional but Recommended)

```bash
kubectl patch storageclass ebs-gp3 \
-p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```

Check:

```bash
kubectl get storageclass
```

⭐ `(default)` should appear

---

## 📦 Create PVC Using EKS StorageClass

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: app-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: ebs-gp3
  resources:
    requests:
      storage: 20Gi
```

Apply:

```bash
kubectl apply -f pvc.yaml
```

---



## 🔹 Use PVC in Pod / Deployment

```yaml
volumes:
- name: data
  persistentVolumeClaim:
    claimName: app-pvc

volumeMounts:
- name: data
  mountPath: /data
```

---

## 🔥 Real-Time Use Cases on EKS

| Application     | Storage |
| --------------- | ------- |
| MySQL / MariaDB | EBS gp3 |
| PostgreSQL      | EBS io1 |
| Jenkins         | EBS gp3 |
| Prometheus      | EBS gp3 |
| Grafana         | EBS gp3 |

🚨 **EBS = ReadWriteOnce**

* One Pod
* One Node
* One AZ


✔ Check:

```bash
kubectl describe pvc app-pvc
```
