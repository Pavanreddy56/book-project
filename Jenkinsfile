pipeline {
    agent any

    tools {
        maven 'Maven3'
        jdk 'JDK17'
    }

    environment {
        IMAGE_NAME = "pavanreddych/book-app"
        IMAGE_TAG  = "${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout Source') {
            steps {
                git branch: 'main', url: 'https://github.com/Pavanreddy56/book-project.git'
            }
        }

        stage('Build Backend') {
            steps {
                echo "Building backend..."
                bat 'mvn clean package -pl backend -am -DskipTests'
            }
        }

        stage('Build Frontend') {
            steps {
                echo "Building frontend..."
                bat 'mvn clean install -pl frontend -am -DskipTests'
            }
        }

        stage('Prepare Docker Context') {
            steps {
                echo "Preparing Docker context..."
                // You can copy backend jar and frontend build if needed, optional now since Dockerfile handles builds
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building combined Docker image..."
                bat "docker build -t %IMAGE_NAME%:%IMAGE_TAG% ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                                                  usernameVariable: 'DOCKERHUB_USER',
                                                  passwordVariable: 'DOCKERHUB_PASS')]) {
                    echo "Logging into Docker Hub..."
                    bat "echo %DOCKERHUB_PASS% | docker login -u %DOCKERHUB_USER% --password-stdin"
                    echo "Pushing Docker image..."
                    bat "docker push %IMAGE_NAME%:%IMAGE_TAG%"
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                echo "Running Docker container..."
                // Stop previous container if exists
                bat 'docker stop book-app || echo "No container running"'
                bat 'docker rm book-app || echo "No container to remove"'
                // Run new container on port 8080
                bat "docker run -d --name book-app -p 8084:8080 %IMAGE_NAME%:%IMAGE_TAG%"
            }
        }
    }

    post {
        always {
            echo "Cleaning up..."
            bat "docker system prune -f"
        }
    }
}

