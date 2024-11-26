pipeline {
    agent any

    environment {
        SONAR_TOKEN = credentials('sonarExamDevops') 
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'master', url: 'https://github.com/AzizMassaoui/Exam_DevOps.git'
            }
        }

        stage('Build Deliverable') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('Sonarqube') {
                    sh "mvn sonar:sonar -Dsonar.login=${SONAR_TOKEN}"
                }
            }
        }
    }
}

