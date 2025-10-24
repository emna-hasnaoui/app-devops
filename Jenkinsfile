pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "emnahasnaoui/mon-app"
    }

        stages {
        stage('Cloner le dépôt') {
            steps {
                git branch: 'main', credentialsId: 'github-creds', url: 'https://github.com/emna-hasnaoui/app-devops.git'
            }
        }

        stage('Construire l\'image Docker') {
            steps {
                bat 'docker build -t %DOCKER_IMAGE% .'
            }
        }

        stage('Pousser l\'image Docker') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
    bat """
        echo %DOCKER_PASSWORD% | docker login -u %DOCKER_USERNAME% --password-stdin
        docker push %DOCKER_IMAGE%
    """
}
            }
        }

        stage('Déployer sur Kubernetes') {
            steps {
                bat 'kubectl apply -f k8s\\deployment.yaml'
                bat 'kubectl apply -f k8s\\service.yaml'
            }
        }
    }
}
