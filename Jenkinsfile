pipeline {
    environment {
      DOCKER_REGISTRY_CREDENTIALS = credentials('dockerhub-login')
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
                  sh 'echo $DOCKER_REGISTRY_CREDENTIALS_PSW | docker login --username $DOCKER_REGISTRY_CREDENTIALS_USR --password-stdin'
                  sh 'docker push lanxic/hello-world:latest'
                }
            }
        }
        stage('Fetch config Aws-Eks') {
          steps {
            script {
              withCredentials([[
                $class: 'AmazonWebServicesCredentialsBinding',
                credentialsId: 'aws-credential',
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
              ]]) {
                  sh 'aws --version'
                  sh 'aws eks update-kubeconfig --name eks-cleanmedic'
                  
              }
            }
          }
        }
    }
}
