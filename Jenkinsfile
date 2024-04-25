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
                withCredentials([gitUsernamePassword(credentialsId: 'github-cmi', gitToolName: 'git-tool')]) {
                    echo 'Updating Image TAG'
                    sh 'sed -i "s/hello-world:.*/hello-world:${VERSION}/g" manifest-repo/values.yaml'
                    echo 'Git Config'
                    // Set Git configurations
                    sh 'git config --global user.email "sysops@cleanmedic.co.id"'
                    sh 'git config --global user.name "Jenkins-ci"'
                    // Add changes
                    sh 'git add manifest-repo/values.yaml'
                    // Commit changes
                    sh 'git commit -am "Update Image tag"'
                    // Push changes to the master branch
                    sh 'git push origin master'
                }
            }
        }
    }
}
