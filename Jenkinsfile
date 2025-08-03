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
                        sh "$ECR_LOGIN_SCRIPT"
                        def ecrRepo = "381491832980.dkr.ecr.us-east-1.amazonaws.com/fintech-api"
                        sh "docker tag $DOCKER_IMAGE $ecrRepo:latest"
                        sh "docker push $ecrRepo:latest"
                    }
                }
            }
        }

        stage('Deploy (Placeholder)') {
            steps {
                echo 'Deployment logic would go here.'
            }