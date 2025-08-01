#!/bin/bash

# Install Docker (if not already installed)
sudo apt update
sudo apt install -y docker.io
sudo systemctl enable docker
sudo usermod -aG docker ubuntu

# Pull Jenkins image
docker pull jenkins/jenkins:lts

# Stop and remove existing Jenkins container if it exists
if docker ps -a --format '{{.Names}}' | grep -Eq "^jenkins$"; then
  echo "⚠️ Removing existing Jenkins container..."
  docker stop jenkins
  docker rm jenkins
fi

# Run Jenkins with Docker socket access
docker run -d --name jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -u root \
  jenkins/jenkins:lts

# Wait for Jenkins to initialize and create password file
echo "⏳ Waiting for Jenkins to be ready..."
for i in {1..60}; do
  if docker exec jenkins test -f /var/jenkins_home/secrets/initialAdminPassword; then
    echo "✅ Jenkins is ready!"
    echo "🔑 Jenkins Initial Password:"
    docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
    exit 0
  fi
  echo "…still waiting ($i/60)"
  sleep 3
done

echo "❌ Timeout reached. Jenkins did not initialize in time."
exit 1
