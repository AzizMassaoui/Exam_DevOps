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

    }
}