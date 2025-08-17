pipeline {
    agent any

    tools {
        maven 'Maven3'    // Maven configured in Jenkins
        jdk 'JDK17'       // JDK configured in Jenkins
    }

    environment {
        IMAGE_NAME = "pavanreddych/book-project1"
        IMAGE_TAG  = "${env.BUILD_NUMBER}"
    }

    stages {

        stage('Checkout Source') {
            steps {
                git branch: 'main', url: 'https://github.com/Pavanreddy56/book-project.git'
            }
        }

        stage('Build with Maven') {
            steps {
                dir('backend') {    // 👈 Go inside backend folder
                    bat 'mvn clean package -DskipTests'
                    bat 'dir target'
                }
            }
        }

        stage('Prepare Docker Context') {
            steps {
                dir('backend') {
                    bat 'copy target\\*.jar ..'   // 👈 copy JAR to root for Docker
                }
                bat 'dir'  // Show root files for confirmation
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    bat "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                                                  usernameVariable: 'DOCKERHUB_USER',
                                                  passwordVariable: 'DOCKERHUB_PASS')]) {
                    bat "echo %DOCKERHUB_PASS% | docker login -u %DOCKERHUB_USER% --password-stdin"
                    bat "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                    bat "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest"
                    bat "docker push ${IMAGE_NAME}:latest"
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful: ${IMAGE_NAME}:${IMAGE_TAG}"
        }
        failure {
            echo "❌ Build, analysis, or deployment failed"
        }
    }
}

