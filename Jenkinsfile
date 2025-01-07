pipeline {
    agent any

    environment {
        DOCKER_COMPOSE_FILE   = 'docker-compose.yml'
        PROJECT_NAME          = 'my_project'
        IMAGE_NAME            = 'flask-app'
        DOCKERHUB_REPO        = 'lidoy/gif_app_project'
        VERSION               = "1.0.${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }

        stage('Build & Deploy') {
            steps {
                script {
                    echo 'Stopping any running containers and cleaning up...'
                    sh """
                        if [ ! -f ${DOCKER_COMPOSE_FILE} ]; then
                            echo "Error: ${DOCKER_COMPOSE_FILE} not found!"
                            exit 1
                        fi
                        docker compose -p ${PROJECT_NAME} down || true
                        docker system prune -f || true
                        docker network prune -f || true
                        docker volume prune -f || true
                    """

                    echo 'Building and starting Docker containers...'
                    withCredentials([
                        usernamePassword(credentialsId: 'db_credentials', usernameVariable: 'DB_USER', passwordVariable: 'DB_PASSWORD')
                    ]) {
                        sh """
                            export MYSQL_ROOT_PASSWORD=\$DB_PASSWORD
                            docker-compose -p ${PROJECT_NAME} build
                            docker-compose -p ${PROJECT_NAME} up -d
                        """
                    }
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    echo 'Testing DB connection...'
                    withCredentials([
                        usernamePassword(credentialsId: 'db_credentials', usernameVariable: 'DB_USER', passwordVariable: 'DB_PASSWORD')
                    ]) {
                        sh """
                            # Wait for MySQL to be ready. For simplicity, a short sleep:
                            sleep 15
                            docker exec mysql_db mysql -u\root -p${DB_PASSWORD} -e "SHOW DATABASES;"
                        """
                    }

                    echo 'Testing application...'
                    sh """
                        # Wait for app to be ready:
                        sleep 15
                        curl -f http://localhost:5001 || (echo 'Application is not running' && exit 1)
                    """
                }
            }
        }

        stage('Publish') {
            steps {
                script {
                    echo 'Tagging and pushing Docker images to Docker Hub...'
                    withCredentials([
                        usernamePassword(credentialsId: 'DOCKERHUB_CREDENTIALS', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')
                    ]) {
                        sh """
                            echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin
                            docker tag ${IMAGE_NAME}:latest ${DOCKERHUB_REPO}/${IMAGE_NAME}:${VERSION}
                            docker tag ${IMAGE_NAME}:latest ${DOCKERHUB_REPO}/${IMAGE_NAME}:latest

                            docker push ${DOCKERHUB_REPO}/${IMAGE_NAME}:${VERSION}
                            docker push ${DOCKERHUB_REPO}/${IMAGE_NAME}:latest
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
        // If you want containers to be torn down after each run:
        always {
            sh "docker compose -p ${PROJECT_NAME} down || true"
        }
    }
}
