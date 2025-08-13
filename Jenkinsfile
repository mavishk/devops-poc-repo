pipeline {
    agent any
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials')
    }

stage('Checkout') {
    steps {
        git branch: 'main', 
            credentialsId: 'github-pat', 
            url: 'https://github.com/mavishk/devops-poc-repo.git'
            }
        }
        stage('Build and Test') {
            steps {
                sh 'python3 -m venv venv && source venv/bin/activate && pip install flask'
                sh 'echo "Running tests..."'
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
                withAWS(region:'us-east-1', credentials:'aws-credentials') {
                    sh 'terraform init && terraform apply -auto-approve'
                }
            }
        }
        stage('Deploy to EKS') {
            steps {
                withAWS(region:'us-east-1', credentials:'aws-credentials') {
                    sh 'kubectl apply -f deployment.yaml'
                }
            }
        }
        stage('Upload Artifacts to S3') {
            steps {
                withAWS(region:'us-east-1', credentials:'aws-credentials') {
                    sh 'aws s3 cp Dockerfile s3://devops-poc-bucket/'
                }
            }
        }
    }
}
