---
title : "CI/CD Pipeline for Backend"
date : 2024-01-01
weight : 1
chapter : false
pre : " <b> 5.8.1. </b> "
---

### CI/CD Pipeline for Backend API Server

We will set up an integration and deployment automation pipeline for the **Backend API Server** (```ticket-booking-backend``` folder) to deploy onto the Beanstalk ```ticket-app-Backend-env``` environment.

---

#### 1. Initialize Git Credentials for IAM User

Before interacting with CodeCommit, initialize your HTTPS Git credentials or security keys for your IAM User:

1. Open the [AWS IAM console](https://us-east-1.console.aws.amazon.com/iam/home#/users).
2. Click your IAM User -> Select the **Security credentials** tab.
3. Scroll down to **HTTPS Git credentials for AWS CodeCommit** -> click **Generate credentials**.
4. Download the CSV containing **Username** and **Password** and store it securely.

![IAM Search](/images/5-Workshop/5.8-CICD-Pipeline/iam_search.png)
![IAM Security Credentials Access Key](/images/5-Workshop/5.8-CICD-Pipeline/iam_user_access_key.png)
![IAM Security Credentials API Keys](/images/5-Workshop/5.8-CICD-Pipeline/iam_user_api_keys.png)

---

#### 2. Configure CI/CD and Push Backend Code

1. Open the [AWS CodeCommit console](https://us-east-1.console.aws.amazon.com/codesuite/codecommit/repositories?region=us-east-1) -> Click **Create repository**.

![CodeCommit Repositories](/images/5-Workshop/5.8-CICD-Pipeline/codecommit_repo_btn.png)

   * **Repository name**: Enter ```ticket-app-backend``` -> click **Create**.

![Create CodeCommit Repository](/images/5-Workshop/5.8-CICD-Pipeline/codecommit_repo_create.png)

2. Open the [AWS CodeBuild console](https://us-east-1.console.aws.amazon.com/codesuite/codebuild/projects?region=us-east-1) -> Click **Create build project**:
   * **Project name**: ```ticket-app-backend-build```.
   * **Source**: Provider: **AWS CodeCommit** | Repository: ```ticket-app-backend``` | Branch: ```main```.

![CodeBuild Backend Source](/images/5-Workshop/5.8-CICD-Pipeline/codebuild_backend_source.png)

   * **Environment**: Operating system: **Amazon Linux** | Runtime: **Standard** | Image: Select latest version (`aws/codebuild/amazonlinux-x86_64-standard:6.0`).

![CodeBuild Backend Environment](/images/5-Workshop/5.8-CICD-Pipeline/codebuild_backend_env.png)

   * **Buildspec**: Select **Insert build commands** -> Switch to editor and enter:
     ```yaml
     version: 0.2
     phases:
       install:
         runtime-versions:
           nodejs: 20
       pre_build:
         commands:
           - npm ci --production
       build:
         commands:
           - echo "Backend build completed on `date`"
     artifacts:
       files:
         - '**/*'
     ```

![CodeBuild Backend Buildspec](/images/5-Workshop/5.8-CICD-Pipeline/codebuild_backend_buildspec.png)

   * **Logs**: Select CloudWatch logs.

![CodeBuild Backend Logs](/images/5-Workshop/5.8-CICD-Pipeline/codebuild_backend_logs.png)

   * Click **Create build project**.

3. Open the [AWS CodePipeline console](https://us-east-1.console.aws.amazon.com/codesuite/codepipeline/pipelines?region=us-east-1) -> click **Create pipeline**:
   * **Pipeline name**: ```ticket-app-backend-pipeline``` -> click **Next**.

![CodePipeline Backend Settings](/images/5-Workshop/5.8-CICD-Pipeline/pipeline_backend_settings.png)

   * **Source stage**: Source: **AWS CodeCommit** | Repository: ```ticket-app-backend``` | Branch: ```main``` -> click **Next**.

![CodePipeline Backend Source Stage](/images/5-Workshop/5.8-CICD-Pipeline/pipeline_backend_source.png)

   * **Build stage**: Build provider: **AWS CodeBuild** | Project name: ```ticket-app-backend-build``` -> click **Next**.

![CodePipeline Backend Build Stage Network](/images/5-Workshop/5.8-CICD-Pipeline/pipeline_backend_network.png)

   * **Deploy stage**: Deploy provider: **AWS Elastic Beanstalk** | Application: ```ticket-app-App``` | Environment: ```ticket-app-Backend-env``` -> click **Next** -> **Create pipeline**.

![CodePipeline Backend Deploy Stage](/images/5-Workshop/5.8-CICD-Pipeline/pipeline_backend_deploy.png)

4. Push Backend code to CodeCommit:
   * Open a Terminal in your Backend directory ```ticket-booking-backend```.
   * Initialize Git and push:
     ```bash
     git init
     git branch -M main
     git remote add origin https://git-codecommit.us-east-1.amazonaws.com/v1/repos/ticket-app-backend
     git add .
     git commit -m "Initial commit Backend API Server"
     git push -u origin main
     ```
     * *Enter the Username and Password downloaded in step 1 when prompted.*

![Clone CodeCommit Repository](/images/5-Workshop/5.8-CICD-Pipeline/codecommit_clone.png)

---

#### 3. Verify Deployment

1. Return to the CodePipeline console.
2. Confirm the ```ticket-app-backend-pipeline``` triggers into **In Progress** state right after pushing.
3. Wait until all stages (Source -> Build -> Deploy) show **Succeeded** (green).

![Backend Pipeline Succeeded](/images/5-Workshop/5.8-CICD-Pipeline/pipeline_backend.png)
![Backend Pipeline List](/images/5-Workshop/5.8-CICD-Pipeline/pipeline_backend_list.png)

4. In the Elastic Beanstalk console, verify the health status of ```ticket-app-Backend-env``` shifts to **Ok** (green).
