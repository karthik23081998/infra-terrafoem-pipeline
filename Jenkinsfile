pipeline {
    agent {
        label 'MYSQL'  // Ensure Terraform, TFLint, and Terrascan are installed here
    }

    environment {
        TF_IN_AUTOMATION = 'true'
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/karthik23081998/infra-terrafoem-pipeline.git'
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws_creds'
                ]]) {
                    sh '''
                        echo "Initializing Terraform..."
                        terraform init -input=false
                    '''
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws_creds'
                ]]) {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Format Check') {
            steps {
                sh 'terraform fmt -check -diff || true'
            }
        }

        stage('Terrascan Security Scan') {
            steps {
                sh 'terrascan scan -t aws || true'
            }
        }

        stage('TFLint Code Linting') {
            steps {
                sh '''
                    tflint --init
                    tflint || true
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws_creds'
                ]]) {
                    sh '''
                        echo "Running Terraform Plan..."
                        terraform plan -out=tfplan
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            when {
                branch 'main'
            }
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws_creds'
                ]]) {
                    input message: 'Approve to apply Terraform changes?'
                    sh 'terraform apply -auto-approve tfplan'
                }
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
            echo "✅ Terraform pipeline completed successfully!"
        }
    }
}
