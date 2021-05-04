pipeline{
    agent any
    stages{
        stage('Git Checkout'){
            steps{
                git credentialsId: '41128789-722c-4ed2-b908-75114cb6f3a4', url: 'https://github.com/linktoakilan/wildflyinfra'
            }
        }
        stage('Terraform Init'){
            steps{
                bat 'terraform init -input=false'
            }
        }
        stage('Terraform Plan'){
            steps{
                bat 'terraform plan -input=false -out tfplan'
                bat 'terraform show -no-color tfplan > tfplan.txt'
            }
        }
        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }

            steps {
                script {
                    def plan = readFile 'tfplan.txt'
                    input message: "Do you want to apply the plan?",
                        parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }
        stage('Terraform Apply'){
            steps{
                bat 'terraform apply -auto-approve -input=false tfplan' 
            }
        }
        stage('Terraform Destroy'){
            steps{
                bat 'terraform destroy -auto-approve' 
            }
        }
            
        }
    post {
        always {
            archiveArtifacts artifacts: 'tfplan.txt'
        }
    }    post {
        always {
            archiveArtifacts artifacts: 'tfplan.txt'
        }
    }
    }
    
