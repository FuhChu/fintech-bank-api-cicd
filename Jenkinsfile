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
                    sh 'docker build -t $DOCKER_IMAGE .'
                }
            }
        }

        stage('Run Unit Tests') {
            steps {
                script {
                    sh 'docker run --rm $DOCKER_IMAGE python3 -m unittest discover -s tests'
                }
            }
        }

        stage('Push to DockerHub (Optional)') {
            when {
                expression { return false } // Change to true when ready
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
