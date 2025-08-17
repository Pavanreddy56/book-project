pipeline {
    agent any

    tools {
        maven 'Maven3'
        jdk 'JDK17'
    }

    environment {
        BACKEND_IMAGE = "pavanreddych/book-backend"
        FRONTEND_IMAGE = "pavanreddych/book-frontend"
        IMAGE_TAG  = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout Source') {
            steps {
                git branch: 'main', url: 'https://github.com/Pavanreddy56/book-project.git'
            }
        }

        stage('Build Backend') {
            steps {
                bat 'mvn clean package -pl backend -am -DskipTests'
            }
        }

        stage('Build Frontend') {
            steps {
                bat 'mvn clean install -pl frontend -am -DskipTests'
            }
        }

        stage('Prepare Docker Context') {
            steps {
                script {
                    bat 'copy backend\\target\\*.jar backend-app.jar'
                    bat 'xcopy /E /I /Y frontend\\dist frontend-dist'
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                bat "docker build -f backend.Dockerfile -t %BACKEND_IMAGE%:%IMAGE_TAG% ."
                bat "docker build -f frontend.Dockerfile -t %FRONTEND_IMAGE%:%IMAGE_TAG% ."
            }
        }

        stage('Push Docker Images') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                                                  usernameVariable: 'DOCKERHUB_USER',
                                                  passwordVariable: 'DOCKERHUB_PASS')]) {
                    bat "echo %DOCKERHUB_PASS% | docker login -u %DOCKERHUB_USER% --password-stdin"
                    bat "docker push %BACKEND_IMAGE%:%IMAGE_TAG%"
                    bat "docker push %FRONTEND_IMAGE%:%IMAGE_TAG%"
                }
            }
        }
    }
}

