#!/bin/bash
set -e

# Update System
apt-get update
apt-get upgrade -y

# Install Java
apt-get install -y openjdk-17-jdk

# Install Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | \
  gpg --dearmor -o /usr/share/keyrings/jenkins-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.gpg] \
  https://pkg.jenkins.io/debian-stable binary/" | \
  tee /etc/apt/sources.list.d/jenkins.list > /dev/null

apt-get update
apt-get install -y jenkins
systemctl enable jenkins
systemctl start jenkins

# Install Docker
apt-get install -y docker.io
usermod -aG docker jenkins
systemctl enable docker
systemctl start docker

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s \
  https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/

# Install gcloud
apt-get install -y apt-transport-https ca-certificates gnupg

echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] \
  https://packages.cloud.google.com/apt cloud-sdk main" | \
  tee /etc/apt/sources.list.d/google-cloud-sdk.list

curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
  gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg

apt-get update
apt-get install -y google-cloud-sdk google-cloud-sdk-gke-gcloud-auth-plugin

# Save Jenkins Info
PUBLIC_IP=$(curl -s \
  "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip" \
  -H "Metadata-Flavor: Google")

echo "Jenkins URL: http://${PUBLIC_IP}:8080" > /root/jenkins-info.txt
echo "Initial Admin Password:" >> /root/jenkins-info.txt
cat /var/lib/jenkins/secrets/initialAdminPassword >> /root/jenkins-info.txt
