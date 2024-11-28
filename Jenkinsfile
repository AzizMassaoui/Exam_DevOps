pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'master', url: 'https://github.com/AzizMassaoui/Exam_DevOps.git'
            }
        }
        stage('Fetch Dockerfile from Working Branch') {
            steps {
                sh '''
                git fetch origin massaoui
		git checkout origin/massaoui -- Dockerfile
                '''
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

        stage('Build Docker Image') {
            steps {
                script {
                    def jarFile = sh(returnStdout: true, script: "ls target/*.jar | grep -v original").trim()
                    echo "Using JAR file: ${jarFile}"
                    sh "docker build -t exam_devops:latest --build-arg JAR_FILE=${jarFile} ."
                }
            }
        }



        stage('Push Docker Image') {
            steps {
                  withCredentials([usernamePassword(credentialsId: 'dockerCreds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
        sh '''
            echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
            docker push $DOCKER_USERNAME/my-image:latest
        '''
    }
            }
        }
    }
}

