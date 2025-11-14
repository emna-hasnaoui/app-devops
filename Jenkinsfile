/*pipeline {
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
                bat 'set KUBECONFIG=C:\\Users\\utili\\.kube\\config && kubectl apply -f k8s\\deployment.yaml'
                bat 'set KUBECONFIG=C:\\Users\\utili\\.kube\\config && kubectl apply -f k8s\\service.yaml'
            }
        }
    }
}*/
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "emnahasnaoui/mon-app"
        HELM_CHART_PATH = "mon-app"       
        KUBE_NAMESPACE = "default"       
    }

    stages {
        stage('Cloner le dépôt') {
            steps {
                git branch: 'main', credentialsId: 'github-creds', url: 'https://github.com/emna-hasnaoui/app-devops.git'
            }
        }

        stage('Préparer le tag') {
            steps {
                script {
                    IMAGE_TAG = "build-${env.BUILD_NUMBER}"
                    IMAGE_FULL = "${DOCKER_IMAGE}:${IMAGE_TAG}"
                    echo "→ Nouvelle image : ${IMAGE_FULL}"
                }
            }
        }

        stage('Construire l\'image Docker') {
            steps {
                bat "docker build -t ${IMAGE_FULL} ."
            }
        }

        stage('Pousser l\'image Docker') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    bat """
                        echo %DOCKER_PASSWORD% | docker login -u %DOCKER_USERNAME% --password-stdin
                        docker push ${IMAGE_FULL}
                    """
                }
            }
        }

        stage('Déployer avec Helm') {
            steps {
                bat """
                    set KUBECONFIG=C:\\Users\\utili\\.kube\\config
                    helm upgrade --install mon-app %HELM_CHART_PATH% ^
                        --namespace %KUBE_NAMESPACE% --create-namespace ^
                        --set image.repository=%DOCKER_IMAGE% ^
                        --set image.tag=${IMAGE_TAG}
                    helm list --namespace %KUBE_NAMESPACE%
                """
            }
        }
    }

    post {
        success {
            echo "✅ Déploiement réussi via Helm : ${IMAGE_FULL}"
        }
        failure {
            echo "❌ Pipeline échoué"
        }
    }
}