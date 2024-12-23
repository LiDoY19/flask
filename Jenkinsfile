pipeline{
    agent any
    
    stages {
        stage ('Checkout SCM'){
            steps{
                echo checkout scm
            }
        }

        stage('build docker image'){
            steps{
                echo "building docker image"
                sh "sudo dcoker build -t lidoy/gif_app_project ."
            }
        }
        stage('Push docker image'){
            when {
                brance "main" //cuz we want to push images to the prod and don't want to push things something in dev
            }
            steps{
                echo "pushing docker images"
            }
        }
    }
}