pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        ECR_REPO = "281934899210.dkr.ecr.us-east-1.amazonaws.com/my-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
        CLUSTER_NAME = "my-cluster"
        SERVICE_NAME = "my-jenkins-service"
    }

    stages {

        stage('Checkout') {
            steps {
               git branch: 'main', url: 'https://github.com/angs-skype/testjenkins.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t my-app .'
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                AWS_PAGER="" aws ecr get-login-password --region $AWS_REGION \
                | docker login --username AWS \
                --password-stdin $ECR_REPO
                '''
            }
        }

        stage('Tag Image') {
            steps {
                sh 'docker tag my-app:latest $ECR_REPO:$IMAGE_TAG'
            }
        }

        stage('Push Image') {
            steps {
                sh 'docker push $ECR_REPO:$IMAGE_TAG'
            }
        }

        stage('Deploy to ECS') {
            steps {
                sh '''
                AWS_PAGER="" aws ecs update-service \
                --cluster $CLUSTER_NAME \
                --service $SERVICE_NAME \
                --force-new-deployment
                '''
            }
        }
        stage('Deploy to EKS') {
           steps {
                  sh '''
                        export KUBECONFIG=/var/jenkins_home/.kube/config

                        kubectl set image deployment/my-app \
                        my-app=$ECR_REPO:$IMAGE_TAG

                        kubectl rollout status deployment/my-app
                    '''
                }
        }
    }
}