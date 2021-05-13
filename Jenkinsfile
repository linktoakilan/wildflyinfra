pipeline {
    agent any
    stages {
        stage('Plan') {
            steps {
                script {
                    currentBuild.displayName = params.version
                }
                bat 'terraform init'
                bat 'terraform plan -auto-approve'
            }
        }

        stage('Apply') {
            steps {
                bat 'terraform apply -auto-approve'
            }
        }
    }
}