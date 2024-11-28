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
        withCredentials([file(credentialsId: 'nexusCreds', variable: 'SETTINGS_FILE')]) {
            sh 'mvn deploy -s $SETTINGS_FILE'
        		}		
    	       }	
	}
        
    }
}

