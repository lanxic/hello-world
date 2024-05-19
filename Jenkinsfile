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
    }

    post {
        success {
            stage('Update Tag Manifest') {
                steps {
                    withCredentials([sshUserPrivateKey(credentialsId: 'github-hw', keyFileVariable: 'key')]) {
                        script {
                            sh """
                            # Set up SSH agent with the provided key
                            eval ${(ssh-agent -s)}
                            ssh-add ${key}
                            
                            # Clone the repository
                            git clone git@github.com:lanxic/manifest-repo.git -b master
                            
                            # Update the image tag in the values.yaml file
                            echo 'Updating Image TAG'
                            sed -i "s/hello-world:.*/hello-world:${VERSION}/g" manifest-repo/hello-world/values.yaml
                            
                            # Configure git user
                            git config --global user.email "lanxic@gmail.com"
                            git config --global user.name "lanxic"
                            
                            # Add and commit changes
                            cd manifest-repo
                            git add hello-world/values.yaml
                            git commit -m "Update Image tag to ${VERSION}"
                            
                            # Push changes back to the repository
                            git push
                            """
                        }
                    }
                }
            }
        }
    }
}
