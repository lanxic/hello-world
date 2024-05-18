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
                  sh 'git clone git@github.com:lanxic/manifest-repo.git -b master'
                  sh 'cd manifest-repo'
                  echo 'Updating Image TAG'
                  sh 'sed -i "s/hello-world:.*/hello-world:${VERSION}/g" hello-world/values.yaml'
                  // Set Git configurations
                  sh 'git config --global user.email "lanxic@gmail.com"'
                  sh 'git config --global user.name "lanxic"'
                  // Add changes
                  sh 'git add hello-world/values.yaml'
                  // Commit changes
                  sh 'git commit -am "Update Image tag"'
                  // Push changes to the master branch
                  // make sure have install ssh-key in server-jenkins
                  sh 'git push git@github.com:lanxic/manifest-repo.git'
                }
            }
        }
    }
}
