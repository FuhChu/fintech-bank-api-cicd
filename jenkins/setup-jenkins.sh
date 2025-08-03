#!/bin/bash

# Exit on error
set -e

echo "🔧 Updating system and installing dependencies..."
sudo apt update && sudo apt install -y \
  docker.io \
  curl \
  gnupg2 \
  openjdk-17-jdk \
  git

echo "🐳 Enabling and starting Docker..."
sudo systemctl enable --now docker
sudo usermod -aG docker $USER

echo "🔐 Adding Jenkins key and repo..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "📦 Installing Jenkins..."
sudo apt update
sudo apt install -y jenkins
sudo usermod -aG docker jenkins

echo "🚀 Starting Jenkins service..."
sudo systemctl enable --now jenkins

echo "⏳ Waiting for Jenkins to initialize..."

# Wait for initial password file
for i in {1..30}; do
  if sudo test -f /var/lib/jenkins/secrets/initialAdminPassword; then
    echo "✅ Jenkins is ready!"
    break
  fi
  echo "⏳ Jenkins not ready yet... ($i/30)"
  sleep 5
done

echo "🔑 Jenkins Initial Admin Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

echo ""
echo "🌐 Access Jenkins at: http://<your-ec2-public-ip>:8080"
echo "⚠️ You may need to log out and back in for Docker group permissions to apply."

# ---------------------------------------------------------------------
# OPTIONAL: Uncomment the following section to use Docker-based Jenkins instead
# ---------------------------------------------------------------------
# echo "🐳 Pulling Jenkins Docker image..."
# docker pull jenkins/jenkins:lts
#
# echo "🧹 Removing any existing Jenkins container..."
# docker rm -f jenkins || true
#
# echo "🐳 Running Jenkins in Docker..."
# docker run -d --name jenkins \
#   -p 8080:8080 -p 50000:50000 \
#   -v jenkins_home:/var/jenkins_home \
#   -v /var/run/docker.sock:/var/run/docker.sock \
#   jenkins/jenkins:lts
#
# echo "⏳ Waiting for Jenkins to be ready inside Docker..."
# for i in {1..30}; do
#   if docker exec jenkins test -f /var/jenkins_home/secrets/initialAdminPassword; then
#     echo "✅ Jenkins Docker is ready!"
#     break
#   fi
#   echo "⏳ Jenkins not ready yet... ($i/30)"
#   sleep 5
# done
#
# echo "🔐 Jenkins Initial Password (Docker):"
# docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
