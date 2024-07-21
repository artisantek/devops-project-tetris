# Tetris Application DevOps Project

This repository contains the source code and infrastructure configuration files for the Tetris Application DevOps Project. The project aims to demonstrate the end-to-end Continuous Integration and Continuous Deployment (CI/CD) pipeline for the Tetris game application.

## Repository Structure

The repository is organized into the following main folders:

1. **Ansible**: Contains Ansible playbooks for configuring the Jenkins Master and Agent instances.
2. **Terraform**: Contains Terraform configuration files to set up the required infrastructure, including EKS (Elastic Kubernetes Service), Ansible Controller, Jenkins Master, and Jenkins Agent.
3. **Tetris-App**: Contains two versions of the Tetris game application along with Helm charts and other related files.

## Prerequisites

Before proceeding with the project, ensure that you have the following prerequisites:

- AWS Account and Access Keys
- Terraform installed
- Snyk Account

## Getting Started

Follow these steps to set up the project:

## Terraform

Terraform is used to automate the creation and management of infrastructure as code. It supports multiple providers such as AWS, Google Cloud, Azure, etc.

### Configuration Steps:

1. Configure AWS credentials using AWS CLI.
2. Navigate to each folder to create resources:
   - `terraform init` - Initialize the directory.
   - `terraform plan` - Display the execution plan.
   - `terraform apply` - Apply the configuration.

## Ansible

Ansible is an open-source automation tool used to automate software provisioning, configuration management, and application deployment.

### Commands to Run Playbooks:

- **Jenkins Master**:
```
  ansible-playbook -i '<jenkins-master-ip>,' -u ubuntu jenkins-master.yaml
```

- **Jenkins Agent**:
```
  ansible-playbook -i '<jenkins-agent-ip>,' -u ubuntu jenkins-agent.yaml
```

## Jenkins

Jenkins is an open-source automation server that enables developers around the world to reliably build, test, and deploy their software. It offers hundreds of plugins to support building, deploying, and automating any project.

### Accessing Jenkins

Access the Jenkins server using the following URL: 
```
http://<jenkins-master-public-ip>:8080
```

## Jenkins Configuration

### 1. Credentials

Jenkins requires the setup of several credentials to facilitate CI/CD processes:

- **awsCred**: Contains AWS Access Key and Secret Key.
- **githubCred**: Contains GitHub username and Git Token.
- **snykCred**: Contains Snyk Auth Token.
- **sonarToken**: Contains SonarQube Token.

Navigate to **Jenkins Dashboard** > **Manage Jenkins** > **Manage Credentials** to add these credentials.

### 2. Jenkins Agent

Connect the Jenkins Agent created via Terraform to the Jenkins Master. This setup involves configuring the agent in **Manage Nodes and Clouds** in the Jenkins settings.

### 3. Plugins

Install essential Jenkins plugins:

- **Sonar Scanner**: For SonarQube integration and code quality checks.
- **Blue Ocean** (Optional): For enhanced CI/CD pipeline visualization.
- **AWS Credential**: For storing AWS Access Key and Secret Key.

Navigate to **Manage Jenkins** > **Manage Plugins** to install these.

### 4. Shared Libraries

Configure Jenkins to use shared libraries for pipeline scripts:

- Go to **Manage Jenkins** > **System Configuration** > **Configure System**.
- Under **Global Pipeline Libraries**, add the library with the repository URL: https://github.com/artisantek/jenkins-sharedlibraries


### 5. SonarQube Integration

SonarQube is a static code analysis tool that helps in identifying bugs, vulnerabilities, and code smells in your source code.

#### Configuration Steps:

- Connect to the SonarQube server running in the container at: 
```
http://<jenkins-agent-public-ip>:9000
```

Initial credentials are `admin` for both username and password.

##### Generate Sonar Token:
- Navigate to **Administration** > **Security** > **Users**.
- Update tokens and add this token as a credential in Jenkins.

##### Quality Gate Configuration:
- Go to **Administration** > **Configuration** > **Webhook**.
- Create a webhook with the URL:
  ```
  http://<jenkins-public-ip>:8080/sonarqube-webhook/
  ```

##### SonarQube Scanner Installation:
- Navigate to **Manage Jenkins** > **Global Tool Configuration**.
- Click on **Add SonarQube Scanner** and configure with:
  - Name: `sonar-scanner`
  - **Install Automatically**

##### Integrate SonarQube Server:
- Navigate to **Manage Jenkins** > **Configure System** > **SonarQube Servers**.
- Click on **add SonarQube** and configure with:
  - Name: `sonar-server`
  - Server URL: `http://<jenkins-agent-public-ip>:9000`
  - Server Authentication Token: `sonarToken Cred`

### 6. Multi-Branch Pipeline

Set up a Multi-Branch Pipeline to automatically build branches and pull requests:

- Navigate to **Jenkins Dashboard** > **New Item**.
- Select **Multibranch Pipeline** and configure source repository and branch discovery behaviors.



