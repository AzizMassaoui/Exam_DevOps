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
                withCredentials([usernamePassword(credentialsId: 'nexusCred', passwordVariable: 'NEXUS_PASSWORD', usernameVariable: 'NEXUS_USERNAME')]) {
                    sh 'mvn clean deploy -Dusername=$NEXUS_USERNAME -Dpassword=$NEXUS_PASSWORD'
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
                withCredentials([usernamePassword(credentialsId: 'dockerCreds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh """
                    docker login -u $DOCKER_USER -p $DOCKER_PASSWORD
                    docker tag exam_devops:latest ${DOCKER_USER}/exam_devops:latest
                    docker push ${DOCKER_USER}/exam_devops:latest
                    """
                }
            }
        }
    }
}

