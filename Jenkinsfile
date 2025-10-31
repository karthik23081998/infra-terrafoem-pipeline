pipeline {
    agent {
        label 'MYSQL'   // Fixed typo: was 'MYAQL'
    }

    environment {
        TF_IN_AUTOMATION = 'true'  // Helps Terraform detect it's running in CI
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/karthik23081998/infra-terrafoem-pipeline.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                    echo "Initializing Terraform..."
                    terraform init -input=false
                '''
            }
        }

        stage('Terraform Validate') {
            steps {
                sh '''
                    echo "Validating Terraform configuration..."
                    terraform validate
                '''
            }
        }

        stage('Terraform Format Check') {
            steps {
                sh '''
                    echo "Checking Terraform formatting..."
                    terraform fmt -check -diff
                '''
            }
        }

        stage('Terrascan Security Scan') {
            steps {
                sh '''
                    echo "Running Terrascan..."
                    terrascan scan -t aws
                '''
            }
        }

        stage('TFLint Code Linting') {
            steps {
                sh '''
                    echo "Running TFLint..."
                    tflint --init
                    tflint
                '''
            }
        }
        stage('plan') {
            steps {
                sh 'plan'
            }
        }
        stage('apply') {
            steps {
                sh 'terraform apply -auto -approve'
            }
        }
    }

    post {
        always {
            echo "Terraform pipeline completed."
        }
        failure {
            echo "❌ Pipeline failed. Check logs for details."
        }
        success {
            echo "✅ Terraform validation and linting passed successfully!"
        }
    }
}
