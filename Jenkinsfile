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
        stage('Update Tag') {
            steps {
                withCredentials([gitUsernamePassword(credentialsId: 'hw-tester', gitToolName: 'git-tool')]) {
                    echo 'Updating Image TAG'
                    sh 'sed -i "s/hello-world:.*/hello-world:${VERSION}/g" manifest-repo/values.yaml'
                    echo 'Git Config'
                    sh 'git config --global user.email "Jenkins@company.com"'
                    sh 'git config --global user.name "Jenkins-ci"'
                    sh 'git add manifest-repo/values.yaml'
                    sh 'git commit -am "Update Image tag"'
                    sh "git push HEAD"
                }
            }
        }
    }
}
