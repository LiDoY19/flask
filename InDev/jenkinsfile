pipeline{
    agent any
    
    stages {
        stage ('Checkout SCM'){
            steps{
                checkout scm
            }
        }

        stage('build docker image'){
            steps{
                echo "building docker image......"
                sh "docker build -t lidoy/gif_app_project ."
            }
        }
        stage('Run docker-compose'){
            steps{
                echo "Runnig docker-compose"
                sh "docker-compose up -d"
            }
        }
        stage('Push docker image'){
            when {
                branch "main" //cuz we want to push images to the prod and don't want to push things something in dev
            }
            steps{
                echo "Pushing docker images....."
            }
        }
    }
}