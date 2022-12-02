node {
    env.BUILD_DIR = "./build-workspace"
    env.MODULE = "web-demo"
    stage('Preparation') {
        git 'https://git.imooc.com/coding-335/mooc-k8s-demo-docker.git'
    }

    stage('Maven Build') {
        sh "mvn -pl ${MODULE} -am clean package"
    }

    stage('Build Image') {
        sh "/script/build-web-image.sh"
    }

    stage('Deploy') {
        sh "/script/deploy.sh"
    }

}