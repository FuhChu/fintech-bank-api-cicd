pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'fintech-api'
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
                withCredentials([
                    string(credentialsId: 'ecr-login-script', variable: 'ECR_LOGIN_SCRIPT'),
                    [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']
                ]) {
                    script {
                        sh(ECR_LOGIN_SCRIPT)
                        def ecrRepo = "911167893459.dkr.ecr.us-east-1.amazonaws.com/fintech-api-ecr"
                        sh "docker tag $DOCKER_IMAGE $ecrRepo:latest"
                        sh "docker push $ecrRepo:latest"
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                // Get the ECR login password on the Jenkins agent, where the AWS credentials are
                def ecrPassword = sh(returnStdout: true, script: 'aws ecr get-login-password --region us-east-1').trim()

                sshagent(['ec2-key']) {
                    // Use a HERE-string for multiline command execution on the remote server
                    // This is more robust than a single, chained command.
                    sh """
                        # Login to ECR on the remote host using the password from the Jenkins agent
                        docker login --username AWS --password-stdin 911167893459.dkr.ecr.us-east-1.amazonaws.com/fintech-api-ecr <<< ${ecrPassword}

                        # Pull the latest image
                        docker pull 911167893459.dkr.ecr.us-east-1.amazonaws.com/fintech-api-ecr/fintech-api:latest

                        # Stop and remove the old container, ignoring any errors if it doesn't exist
                        docker rm -f fintech-api || true

                        # Run the new container, mapping host port 3000 to container port 5000
                        docker run -d --name fintech-api -p 3000:5000 \\
                        911167893459.dkr.ecr.us-east-1.amazonaws.com/fintech-api-ecr/fintech-api:latest
                    """
                }
            }
        }
    }
}