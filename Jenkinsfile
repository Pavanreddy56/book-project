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
                // 👇 Run Maven from the root, it will build parent + backend
                bat 'mvn clean package -DskipTests'
            }
        }

        stage('Prepare Docker Context') {
            steps {
                dir('backend') {
                    // 👇 Copy backend JAR to project root for Docker
                    bat 'copy target\\*.jar ..'
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

        stage('Run Docker Container') {
            steps {
                script {
                    // Run on port 8081 instead of 8080 (since Jenkins uses 8080)
                    bat "docker run -d -p 8081:8080 --name book-app-${BUILD_NUMBER} ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful: ${IMAGE_NAME}:${IMAGE_TAG}"
            echo "🌍 App running on http://localhost:8081"
        }
        failure {
            echo "❌ Build, analysis, or deployment failed"
        }
    }
}

