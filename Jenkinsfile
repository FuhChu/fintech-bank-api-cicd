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

        stage('Push to DockerHub (Optional)') {
            when {
                expression { return false }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    script {
                        sh "docker login -u $USERNAME -p $PASSWORD"
                        sh "docker tag $DOCKER_IMAGE $USERNAME/$DOCKER_IMAGE"
                        sh "docker push $USERNAME/$DOCKER_IMAGE"
                    }
                }
            }
        }

        stage('Deploy (Placeholder)') {
            steps {
                echo 'Deployment logic would go here.'
            }
        }
    }
}
