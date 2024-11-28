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
        
        stage('Build Docker Image') {
            steps {
                script {
                    def jarFile = sh(script: "ls target/*.jar | grep -v original", returnStdout: true).trim()
                    echo "Using JAR file: ${jarFile}"
                    withCredentials([usernamePassword(credentialsId: 'dockerCreds', usernameVariable: 'DOCKER_USER')]) {
                        sh """
                        docker build -t $DOCKER_USER/exam-devops:latest --build-arg JAR_FILE=${jarFile} .
                        """
                    }
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerCreds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                    docker login -u $DOCKER_USER -p $DOCKER_PASS
                    docker push $DOCKER_USER/exam-devops:latest
                    """
                }
            }
        }
    }
}

