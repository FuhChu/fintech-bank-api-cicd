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
#!/bin/bash

echo "Waiting for Jenkins to be ready..."

# Wait up to 90 seconds for Jenkins to finish initializing
for i in {1..30}; do
  if docker exec jenkins test -f /var/jenkins_home/secrets/initialAdminPassword; then
    echo "Jenkins is ready!"
    break
  fi
  echo "Jenkins not ready yet... ($i)"
  sleep 3
done

# Now print the password
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
