pipeline {
    agent {
        label 'MYSQL'  // Make sure this agent has Terraform, Terrascan, and TFLint installed
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
                withCredentials([aws(credentialsId: 'aws_creds', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh '''
                        echo "Initializing Terraform..."
                        terraform init -input=false
                    '''
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                withCredentials([aws(credentialsId: 'aws_creds', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Format Check') {
            steps {
                sh 'terraform fmt -check -diff || true'  // don't fail for formatting
            }
        }

        stage('Terrascan Security Scan') {
            steps {
                sh 'terrascan scan -t aws || true'  // don't fail pipeline if warnings
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
                withCredentials([aws(credentialsId: 'aws_creds', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
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
                withCredentials([aws(credentialsId: 'aws_creds', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
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
