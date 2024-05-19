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
                withCredentials([sshUserPrivateKey(credentialsId: 'github-hw', keyFileVariable: 'SSH_KEY')]) {
                    script {
                        def repoDir = "${WORKSPACE}/manifest-repo"
                        try {
                            // Clone the repository using SSH key into a specific directory
                            sh "rm -rf '${repoDir}'"  // Clean up if the directory already exists
                            sh "git clone git@github.com:lanxic/manifest-repo.git '$repoDir'"
                            dir("$repoDir") {
                                echo 'Updating Image TAG'

                                // Update the image tag in the values.yaml file
                                sh "sed -i 's/hello-world:.*/hello-world:$VERSION/g' hello-world/values.yaml"

                                echo 'Git Config'

                                // Set Git configurations
                                sh 'git config --global user.email "lanxic@gmail.com"'
                                sh 'git config --global user.name "lanxic"'

                                // Add changes
                                sh 'git add hello-world/values.yaml'

                                // Commit changes
                                sh "git commit -m 'Update Image tag to $VERSION'"

                                // Push changes to the master branch using the SSH key
                                sh "GIT_SSH_COMMAND='ssh -i $SSH_KEY' git push origin master"
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
