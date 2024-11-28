pipeline {
    agent any

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
                    sh "mvn sonar:sonar -Dsonar.projectKey=Exam_DevOps"
                }
            }
        }
        
        stage('Deploy to Nexus') {
            steps {
    		
                    sh 'mvn clean deploy -s /settings.xml'
		}
        }
        
    }
}

