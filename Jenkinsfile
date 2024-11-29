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
                    // Build and tag with your Docker Hub username
                    sh "docker build -t azizmassaoui/exam_devops:latest --build-arg JAR_FILE=${jarFile} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerCreds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh '''
                        echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                        docker push $DOCKER_USERNAME/exam_devops:latest
                    '''
                }
            }
        }
        
        post {
        failure {
            script {
                emailext(
                    to: "massaouiaziz0@gmail.com",
                    subject: "Pipeline Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                    body: """
                    Hello Aziz,

                    The pipeline '${env.JOB_NAME}' has failed during build #${env.BUILD_NUMBER}.

                    **Stage**: ${env.STAGE_NAME}

                    **Error Details**: The error occurred in the pipeline stages.
                    Attached is the full build log for reference.

                    You can also view the detailed logs [here](${env.BUILD_URL}).

                    Regards,  
                    Jenkins Pipeline
                    """,
                    attachLog: true
                )
            }
        }

        success {
            script {
                emailext(
                    to: "massaouiaziz0@gmail.com",
                    subject: "Pipeline Succeeded: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                    body: """
                    Hello Aziz,

                    The pipeline '${env.JOB_NAME}' has successfully completed.

                    **Details**:
                    - Build Number: ${env.BUILD_NUMBER}
                    - View the full details: [Pipeline Logs](${env.BUILD_URL})

                    Regards,  
                    Jenkins Pipeline
                    """
                )
            }
        }
        
        
    		}
	}
}
