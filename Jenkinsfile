pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "your_dockerhub_username/ecu-firmware"
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials'
        AWS_EC2_IP = 'your-ec2-public-ip'
        SSH_KEY_CRED_ID = 'ec2-ssh-key'  // SSH Key ID stored in Jenkins
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Clone the code from GitHub
                git url: 'https://github.com/yourusername/ecu-firmware.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    docker.build("${DOCKER_IMAGE}:${BUILD_NUMBER}")
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    // Log in and push the Docker image to Docker Hub
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_CREDENTIALS_ID}") {
                        docker.image("${DOCKER_IMAGE}:${BUILD_NUMBER}").push()
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    // Pull and run the Docker image on EC2
                    sshagent(['${SSH_KEY_CRED_ID}']) {
                        sh """
                        ssh -o StrictHostKeyChecking=no ec2-user@${AWS_EC2_IP} << EOF
                        docker pull ${DOCKER_IMAGE}:${BUILD_NUMBER}
                        docker stop firmware_container || true
                        docker rm firmware_container || true
                        docker run -d --name firmware_container ${DOCKER_IMAGE}:${BUILD_NUMBER}
                        EOF
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
