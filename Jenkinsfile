pipeline {
    environment {
        AWS_DEFAULT_REGION = 'ap-southeast-3 '
    }

    agent any

    stages {
        stage('Build-Docker-Image') {
            steps {
                script {
                    // Run steps inside a Docker container
                    container('lanxic/hello-world') {
                        sh 'docker build -t lanxic/hello-world:latest .'
                    }
                }
            }
        }
        stage('Login and Push to Docker Hub') {
            steps {
                script {
                    // Run steps inside a Docker container
                    container('lanxic/hello-world') {
                        // Use Credentials Binding Plugin to securely retrieve Docker Hub credentials
                        withCredentials([usernamePassword(credentialsId: 'dockerhub-login', usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                            sh "echo \$DOCKER_HUB_PASSWORD | docker login --username \$DOCKER_HUB_USERNAME --password-stdin"
                            sh 'docker push lanxic/hello-world:latest'
                        }
                    }
                }
            }
        }
    }
}
