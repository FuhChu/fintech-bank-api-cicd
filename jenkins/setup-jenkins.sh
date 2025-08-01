#!/bin/bash

# Install Docker
sudo apt update
sudo apt install -y docker.io
sudo systemctl enable docker
sudo usermod -aG docker ubuntu

# Pull Jenkins
docker pull jenkins/jenkins:lts

# Run Jenkins
# Run Jenkins with Docker socket access
docker run -d --name jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -u root \
  jenkins/jenkins:lts

# Output unlock password
echo "Waiting for Jenkins to be ready..."

for i in {1..30}; do
  if docker exec jenkins test -f /var/jenkins_home/secrets/initialAdminPassword; then
    echo "✅ Jenkins is ready!"
    break
  fi
  echo "⏳ Jenkins not ready yet... ($i/30)"
  sleep 3
done

echo "Jenkins Initial Password:"
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
