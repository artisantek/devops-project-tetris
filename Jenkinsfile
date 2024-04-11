@Library('sharedlibrary')_

pipeline {
    environment {
        gitRepoURL = "${env.GIT_URL}"
        gitBranchName = "${env.BRANCH_NAME}"
        repoName = sh(script: "basename -s .git ${GIT_URL}", returnStdout: true).trim()
        dockerImage = "227219889473.dkr.ecr.ap-south-1.amazonaws.com/${repoName}"
        branchName = sh(script: 'echo $BRANCH_NAME | sed "s#/#-#"', returnStdout: true).trim()
        gitCommit = "${GIT_COMMIT[0..6]}"
        dockerTag = "${branchName}-${gitCommit}"
    }
    
    agent {label 'docker'}
    stages {
        stage('Git Checkout') {
            steps {
                gitCheckout("$gitRepoURL", "refs/heads/$gitBranchName", 'githubCred')
            }
        }

        stage('Docker Build') {
            steps {
                dir('tetris-app/version1') {
                    dockerImageBuild('$dockerImage', '$dockerTag')
                }
            }
        }

        stage('Docker Push') {
            steps {
                dockerECRImagePush('$dockerImage', '$dockerTag', '$repoName', 'awsCred', 'ap-south-1')
            }
        }

        stage('Kubernetes Deploy - DEV') {
            when {
                branch 'development'
            }
            steps {
                dir('tetris-app/version1') {
                    kubernetesEKSHelmDeployEnv('$dockerImage', '$dockerTag', '$repoName', 'awsCred', 'ap-south-1', 'eks-cluster', 'dev')
                }
            }
        }

        stage('Kubernetes Deploy - UAT') {        
            when {
                branch 'master_staging'
            }
            steps {
                dir('tetris-app/version1') {
                    kubernetesEKSHelmDeployEnv('$dockerImage', '$dockerTag', '$repoName', 'awsCred', 'ap-south-1', 'eks-cluster', 'uat')
                }
            }
        }

        stage('Kubernetes Deploy - PROD') {
            when {
                branch 'master'
            }
            steps {
                dir('tetris-app/version1') {
                    kubernetesEKSHelmDeployEnv('$dockerImage', '$dockerTag', '$repoName', 'awsCred', 'ap-south-1', 'eks-cluster', 'prod')
                }
            }
        }

    }
}