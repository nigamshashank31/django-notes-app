@Library("shared") _
pipeline{
    agent { 
        label 'node1'
    }
    environment {
        PROJECT_DIR = '/home/shashank_nigam/workspace/DjangoCICD'
        IMAGE_NAME = 'django_app'   // as in your docker-compose.yml
        PATH = "/usr/bin:$PATH"
    }
    triggers {
        pollSCM('H/5 * * * *')   // Poll SCM every 5 minutes
    }
    stages {
        stage('Mahadev'){
            steps{
                script{
                    hello()
                }
            }
        }
        stage('Clone-Repo'){
            steps{
                script{
                    clone('https://github.com/nigamshashank31/django-notes-app.git','main')
                }
            }
        }
        stage("Build"){
            steps {
                echo 'Building docker images with docker-compose'
                dir(PROJECT_DIR){
                    sh 'docker-compose build'
            }
        }
    }  
    stage("Push to Docker Hub"){
        steps {
            echo 'Pushing Docker image to Docker Hub'
            withCredentials([usernamePassword(
                credentialsId: 'dockerHubCred', 
                usernameVariable: 'dockerHubUser', 
                passwordVariable: 'dockerHubPass')]){
            sh """docker login -u $dockerHubUser -p $dockerHubPass"""
            sh """docker image tag django_app $dockerHubUser/django_app"""
            sh """docker push $dockerHubUser/django_app"""
            }
        }
    }
        stage("Test"){
            steps{
                echo 'No tests configured yet'
            }
        }
        stage('Deploy'){
            steps{
                echo 'Stopping and removing old containers, starting new ones'
                dir(PROJECT_DIR){
                    sh 'docker-compose down'   // Stop and remove old containers
                    sh 'docker-compose up -d'  // Start containers in detached mode
                }
            }
        }
        stage("Verify"){
            steps {
                echo 'Check containers status'
                dir(PROJECT_DIR) {
                    sh 'docker-compose ps'
                    sh 'docker-compose logs django_app --tail=50'
                }
            }
    }
}    
post {
        failure {
            echo "Build failed, dumping docker status"
            dir(PROJECT_DIR) {
                sh 'docker ps -a || true'
            }
        }
    }
}

