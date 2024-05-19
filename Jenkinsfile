pipeline {
    environment {
      DOCKER_REGISTRY_CREDENTIALS = credentials('dockerhub-login')
      AWS_DEFAULT_REGION = 'ap-southeast-3'
      VERSION = "${env.BUILD_ID}"
    }

    agent any

    stages {
        stage('Clean-Docker-Image') {
          steps {
            script {
              sh 'docker system prune --all --force'
            }
          }
        }
        stage('Build-Docker-Image') {
          steps {
              script {
                sh "docker build -t lanxic/hello-world:${VERSION} ."
              }
          }
        }
        stage('Login and Push to Docker Hub') {
            steps {
                script {
                  sh 'echo $DOCKER_REGISTRY_CREDENTIALS_PSW | docker login --username $DOCKER_REGISTRY_CREDENTIALS_USR --password-stdin'
                  sh "docker push lanxic/hello-world:${VERSION}"
                }
            }
        }
        stage('Update Tag Manifest') {
            steps {
                script {
                   sh "/var/lib/jenkins/scripts/update-manifest.sh ${VERSION}"
                }
            }
        }
    }
}
