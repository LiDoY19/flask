pipeline {
    agent any

    environment {
        DOCKER_COMPOSE_FILE = 'docker-compose.yaml' // The docker-compose file name
        APP_SERVICE_NAME = 'my_app_service' // Replace with your main service name in docker-compose
        VERSION = "1.0.${BUILD_NUMBER}" // Generate a unique version tag
        DB_USER = credentials('db_user') // Securely retrieve the database username
        DB_PASSWORD = credentials('db_password') // Securely retrieve the database password
        DB_HOST = 'localhost' // Non-sensitive: database host
        DB_NAME = 'mydatabase' // Non-sensitive: database name
        DB_PORT = '3307' // Non-sensitive: DATA BASE port
    }

    stages {
        stage('Checkout SCM') {
            steps {
                echo 'Checking out source code from SCM...'
                checkout scm // Pull the latest code from source control
            }
        }

        stage('Clean Running Containers') {
            steps {
                script {
                    echo 'Checking and stopping running containers...'
                    sh """
                    # Check if docker-compose.yaml exists
                    if [ -f ${DOCKER_COMPOSE_FILE} ]; then
                        echo 'Found docker-compose.yaml. Stopping running containers...'
                        docker-compose down || echo 'No containers to stop.' // Stop containers if they are running
                    else
                        echo '${DOCKER_COMPOSE_FILE} not found in workspace.'
                        exit 1 // Exit pipeline if docker-compose file is missing
                    fi

                    # Optional: Clean unused resources
                    docker system prune -f || true
                    """
                }
            }
        }

    stage('Build and Deploy') {
        steps {
            script {
                echo 'Building and starting services with docker-compose...'
                withCredentials([
                    usernamePassword(credentialsId: 'db_credentials', usernameVariable: 'DB_USER', passwordVariable: 'DB_PASSWORD')
                ]) {
                    sh """
                    # Export sensitive information as environment variables
                    export DB_USER=${DB_USER}
                    export DB_PASSWORD=${DB_PASSWORD}
                    export DB_HOST=${DB_HOST}
                    export DB_NAME=${DB_NAME}
                    export DB_PORT=${PORT}
                    
                    # Build and start Docker containers
                    docker-compose build
                    docker-compose up -d
                    """
                }
            }
        }
    }

        stage('Testing') {
            steps {
                script {
                    echo 'Running curl tests to verify the application...'
                    sh """
                    sleep 10 # Wait for containers to initialize
                    curl -f http://localhost:5001 || (echo 'Application is not running' && exit 1) // Test the application
                    echo 'Application is running as expected.'
                    """
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    echo 'Tagging and pushing Docker images to Docker Hub...'

                    withCredentials([
                        usernamePassword(credentialsId: 'DOCKERHUB_CREDENTIALS', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')
                    ]) {
                        sh """
                        echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin // Secure login to Docker Hub
                        
                        # Tag and push the images
                        VERSION="1.0.${BUILD_NUMBER}" // Generate version tag
                        echo "Generated version tag: ${VERSION}"
                        
                        docker tag your-app:latest your-dockerhub-repo/your-app:${VERSION}
                        docker tag your-app:latest your-dockerhub-repo/your-app:latest

                        docker push your-dockerhub-repo/your-app:${VERSION} // Push versioned tag
                        docker push your-dockerhub-repo/your-app:latest // Push latest tag

                        echo "Docker images pushed: ${VERSION} and latest."
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!' // Success message
        }
        failure {
            echo 'Pipeline failed. Check the logs for details.' // Failure message
        }
    }
}
