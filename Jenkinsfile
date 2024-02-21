pipeline {
    agent {
        node {
            label 'agent1'
        }
    }
    stages {
        stage('Build-Docker-Image') {
            steps {
                script {
                    docker.build("lanxic/hello-world:latest")
                }
            }
        }
        stage('Login and Push to register hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-login', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        docker.withRegistry('https://registry.hub.docker.com', 'docker') {
                            docker.login(username: USERNAME, password: PASSWORD)
                            docker.image("lanxic/hello-world:latest").push()
                        }
                    }
                }
            }
        }
        stage('Fetch config Aws-Eks') {
            steps {
                script {
                    withCredentials([awsAccessKey(credentialsId: 'aws-credential', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh 'aws --version'
                        sh 'aws eks update-kubeconfig --name eks-cleanmedic'
                    }
                }
            }
        }
        stage('Restart pod') {
            steps {
                script {
                    def podNames = sh(script: 'kubectl get pods -n dev -o name | grep hello-world', returnStdout: true).trim()
                    if (podNames) {
                        podNames.split().each { pod ->
                            def podName = pod.replaceFirst('pod/', '')
                            sh "kubectl delete pod $podName -n dev"
                        }
                    } else {
                        echo "No pods found matching the criteria."
                    }
                }
            }
        }
    }
}
