pipeline {
  environment {
    CONTAINER_REGISTRY_CREDENTIALS = credentials('dockerhub-login')
    AWS_DEFAULT_REGION = 'ap-southeast-3'
  }

  agent any
  stages {
      stage('Build-Docker-Image') {
        steps {
          container('docker') {
            sh 'docker build -t lanxic/hello-world:latest .'
          }
        }
      }
      stage('Login and Push to register hub') {
          steps {
              script {
                  // Run steps inside a Docker container
                  container('docker') {
                      sh 'echo $CONTAINER_REGISTRY_CREDENTIALS_PSW | docker login --username $CONTAINER_REGISTRY_CREDENTIALS_USR --password-stdin'
                      sh 'docker push lanxic/hello-world:latest'
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
      // stage('Restart pod') {
      //     steps {
      //         script {
      //             def podNames = sh(script: 'kubectl get pods -n dev -o name | grep hello-world', returnStdout: true).trim()
      //             if (podNames) {
      //                 podNames.split().each { pod ->
      //                     def podName = pod.replaceFirst('pod/', '')
      //                     sh "kubectl delete pod $podName -n dev"
      //                 }
      //             } else {
      //                 echo "No pods found matching the criteria."
      //             }
      //         }
      //     }
      // }
  }
}
