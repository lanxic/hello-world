pipeline {
    environment {
        AWS_DEFAULT_REGION = 'ap-southeast-3'
    }

    agent any

    stages {
        stage('Build-Docker-Image') {
            steps {
                script {
                    // Build the Docker image
                    sh 'docker build -t lanxic/hello-world:latest .'
                }
            }
        }
        stage('Login and Push to Docker Hub') {
            steps {
                script {
                    // Use Credentials Binding Plugin to securely retrieve Docker Hub credentials
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-login', usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                        // Login to Docker Hub
                        sh "echo \$DOCKER_HUB_PASSWORD | docker login --username \$DOCKER_HUB_USERNAME --password-stdin"
                        // Push the Docker image to Docker Hub
                        sh 'docker push lanxic/hello-world:latest'
                    }
                }
            }
        }
    }
}
