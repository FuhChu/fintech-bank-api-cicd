pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'fintech-api'
        ECR_REGISTRY = "911167893459.dkr.ecr.us-east-1.amazonaws.com"
        ECR_REPOSITORY = "${ECR_REGISTRY}/fintech-api-ecr"
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/FuhChu/fintech-bank-api-cicd.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'echo "--- Listing files inside ./app ---" && ls -l ./app'
                    sh 'docker build -t $DOCKER_IMAGE ./app'
                }
            }
        }

        stage('Run Unit Tests') {
            steps {
                script {
                    sh 'docker run --rm -v /var/lib/jenkins/workspace/fintech-bank-api-cicd/app:/app -w /app fintech-api python3 -m unittest discover -s .'
                }
            }
        }

        stage('Push to ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
                    script {
                        sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${ECR_REGISTRY}"
                        sh "docker tag $DOCKER_IMAGE ${ECR_REPOSITORY}:latest"
                        sh "docker push ${ECR_REPOSITORY}:latest"
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    sshagent(['ec2-key']) {
                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
                            sh """
                                # Login to ECR on the remote host using the password from the Jenkins agent
                                aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${ECR_REGISTRY}

                                # Pull the latest image
                                docker pull ${ECR_REPOSITORY}:latest

                                # Stop and remove the old container, ignoring any errors if it doesn't exist
                                docker rm -f fintech-api || true

                                # Run the new container, mapping host port 3000 to container port 5000
                                docker run -d --name fintech-api -p 3000:5000 ${ECR_REPOSITORY}:latest
                            """
                        }
                    }
                }
            }
        }
    }
}