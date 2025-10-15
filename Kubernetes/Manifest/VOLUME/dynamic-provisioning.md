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
