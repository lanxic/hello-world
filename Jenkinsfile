pipeline {
    environment {
        DOCKER_REGISTRY_CREDENTIALS = credentials('dockerhub-login')
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
                    sh 'echo $DOCKER_REGISTRY_CREDENTIALS_PSW | docker login --username $DOCKER_REGISTRY_CREDENTIALS_USR --password-stdin registry.wwwaste.io'
                    sh "docker push registry.wwwaste.io/hello-world:${VERSION}"
                }
            }
        }
        
        stage('K8S') {
            withCredentials([sshUserPrivateKey(credentialsId: 'github-hw', keyFileVariable: 'SSH_KEY')]) {
            def repoDir = "${WORKSPACE}/manifest-repo"
            echo 'Updating Image TAG'
            try {
                sh "rm -rf '${repoDir}'"
                sh "git clone git@github.com:lanxic/manifest-repo.git '$repoDir'"
                dir("$repoDir") {
                echo 'Updating Image TAG'
                sh "sed -i 's/hello-world:.*/hello-world:$VERSION/g' hello-world/values.yaml"
                echo 'Git Config'
                sh 'git config --global user.email "sysadmin@cleanmedicindus.com"'
                sh 'git config --global user.name "sysadmin"'
                sh 'git add hello-world/values.yaml'
                sh "git commit -m 'Update Image tag to $VERSION'"
                sh "git push origin master"
                }
            } catch (Exception e) {
                echo "An error occurred: ${e.getMessage()}"
                currentBuild.result = 'FAILURE'
                throw e
            }
            }
        }
    }
}
