#!/bin/bash

# Install Docker
sudo apt update
sudo apt install -y docker.io
sudo systemctl enable docker
sudo usermod -aG docker ubuntu

# Pull Jenkins
docker pull jenkins/jenkins:lts

# Run Jenkins
docker run -d --name jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts

# Output unlock password
echo "Jenkins Initial Password:"
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
