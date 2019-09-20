pipeline {
    agent {
        docker {
            image 'oavkdtv/centos-node:1.0.0' 
            args '-p 3555:3000' 
        }
    }
    environment {
        CI = 'true' 
    }
    stages {
        stage('Build') { 
            steps {
                sh 'npm config set http-proxy http://10.252.64.33:8080'
                sh 'npm config set https-proxy http://10.252.64.33:8080'
                sh 'npm install' 
            }
        }
        stage('Test') { 
            steps {
                sh 'npm run test:ci' 
            }
        }
    }
}
node {
    stage 'Checkout'
        git url: 'https://github.com/juicejuz/tes-api.git'
    stage 'Build Docker'
        docker.build('davedb-app-test --build-arg HTTPS_PROXY=http://10.252.64.33:8080 --build-arg HTTP_PROXY=http://10.252.64.33:8080')
    stage 'deploy'
        /*sh 'docker stack deploy -c docker-compose.yml davedb-app'*/
        /*sh 'docker service create --name davedb-app --network davedb_network --publish 3555:3000 --replicas=1 --constraint "node.role == manager" davedb-app-test'*/
        sh 'docker run -it -d --name dave-app -p 3555:3000 davedb-app-test'
}