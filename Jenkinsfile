pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials')
    }
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/mavishk/devops-poc-repo.git'
            }
        }
        stage('Build and Test') {
            steps {
                sh 'python3 -m venv venv && source venv/bin/activate && pip install flask'
                sh 'echo "Running tests..."' // Add test commands
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t myflaskapp:latest .'
            }
        }
        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                    sh 'docker tag myflaskapp:latest $DOCKER_USERNAME/myflaskapp:latest'
                    sh 'docker push $DOCKER_USERNAME/myflaskapp:latest'
                }
            }
        }
        stage('Provision EKS') {
            steps {
                sh 'terraform init && terraform apply -auto-approve'
            }
        }
        stage('Deploy to EKS') {
            steps {
                sh 'kubectl apply -f deployment.yaml' // Or use Helm
            }
        }
        stage('Upload Artifacts to S3') {
            steps {
                sh 'aws s3 cp Dockerfile s3://devops-poc-bucket/'
            }
        }
    }
}
