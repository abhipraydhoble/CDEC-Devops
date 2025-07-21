

# SonarQube Installation Steps

### ✅ Step 1: Install Java

SonarQube requires Java. Install OpenJDK 11:

```bash
sudo apt-get update && sudo apt-get install -y openjdk-11-jdk
```

---

### ✅ Step 2: Install Unzip Utility

```bash
sudo apt-get install -y unzip
```

---

### ✅ Step 3: Create SonarQube User

Switch to `root` user and create a new user `sonarqube`:

```bash
sudo adduser sonarqube
```

---

### ✅ Step 4: Download and Extract SonarQube

Switch to `sonarqube` user:

```bash
su - sonarqube
```

Download SonarQube:

```bash
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.4.0.54424.zip
unzip sonarqube-9.4.0.54424.zip
```

---

### ✅ Step 5: Set Permissions

Switch back to `root` user:

```bash
sudo chmod -R 755 /home/sonarqube/sonarqube-9.4.0.54424
sudo chown -R sonarqube:sonarqube /home/sonarqube/sonarqube-9.4.0.54424
```

---

### ✅ Step 6: Start SonarQube

Switch to `sonarqube` user:

```bash
su - sonarqube
cd sonarqube-9.4.0.54424/bin/linux-x86-64/
./sonar.sh start
```

---

## 🔍 Access SonarQube

Open your browser and go to:

```
http://<your-server-ip>:9000
```

Default credentials:

* **Username:** `admin`
* **Password:** `admin`

---

## 🎉 SonarQube is Ready!


