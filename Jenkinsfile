pipeline {
    environment {
        DOCKER_REGISTRY_CREDENTIALS = credentials('registry-wwwaste-login')
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
                    sh "docker build -t registry.wwwaste.io/hello-world:${VERSION} ."
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
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'github-hw', keyFileVariable: 'SSH_KEY')]) {
                    script {
                        def repoDir = "${WORKSPACE}/manifest-repo"
                        echo 'Starting K8S Stage: Updating Image TAG'

                        try {
                            // Clean up any existing repo directory
                            sh "rm -rf '${repoDir}'"

                            // Clone the repository using the SSH key
                            sh "git clone git@github.com:lanxic/manifest-repo.git '$repoDir'"

                            // Navigate to the repo directory and update the image tag
                            dir("$repoDir") {
                                echo 'Updating Image TAG in values.yaml'
                                sh "sed -i 's/hello-world:.*/hello-world:$VERSION/g' hello-world/values.yaml"

                                // Git configuration
                                echo 'Configuring Git'
                                sh 'git config --global user.email "sysadmin@cleanmedicindus.com"'
                                sh 'git config --global user.name "sysadmin"'

                                // Commit and push the changes
                                echo 'Committing and pushing changes'
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

    }
}
