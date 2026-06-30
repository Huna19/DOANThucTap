---
title : "CI/CD Pipeline for Worker"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.8.2. </b> "
---

### CI/CD Pipeline for Worker Server

We will set up an integration and deployment automation pipeline for the **Worker Server** (```ticket-booking-worker``` folder) to deploy onto the Beanstalk ```ticket-app-Worker-env``` environment.

---

#### 1. Configure CI/CD and Push Worker Code

1. **Create CodeCommit Repository**:
   * Open the CodeCommit console -> Click **Create repository** -> Name: ```ticket-app-worker``` -> click **Create**.
2. **Create CodeBuild Project**:
   * Open the CodeBuild console -> Click **Create build project**:
     * **Project name**: ```ticket-app-worker-build```.
     * **Source**: Provider: **AWS CodeCommit** | Repository: ```ticket-app-worker``` | Branch: ```main```.
     * **Environment**: Operating system: **Amazon Linux** | Runtime: **Standard** | Image: Select latest version (`aws/codebuild/amazonlinux2-x86_64-standard:5.0`).
     * **Buildspec**: Enter:
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
             - echo "Worker build completed on `date`"
       artifacts:
         files:
           - '**/*'
       ```
     * Click **Create build project**.
3. **Create CodePipeline**:
   * Open the CodePipeline console -> click **Create pipeline**:
     * **Pipeline name**: ```ticket-app-worker-pipeline```.
     * **Source stage**: Repository: ```ticket-app-worker``` | Branch: ```main```.
     * **Build stage**: Project name: ```ticket-app-worker-build```.
     * **Deploy stage**: Deploy provider: **AWS Elastic Beanstalk** | Application: ```ticket-app-App``` | Environment: ```ticket-app-Worker-env``` -> click **Create pipeline**.

4. **Push Worker code to CodeCommit**:
   * Open a Terminal in your Worker directory ```ticket-booking-worker```.
   * Initialize Git and push:
     ```bash
     git init
     git branch -M main
     git remote add origin https://git-codecommit.us-east-1.amazonaws.com/v1/repos/ticket-app-worker
     git add .
     git commit -m "Initial commit Worker Server"
     git push -u origin main
     ```
     * *Enter your Git CodeCommit credentials when prompted.*

![CodeCommit Repository Worker](/images/5-Workshop/5.8-CICD-Pipeline/codecommit_worker.png)

---

#### 2. Verify Deployment

1. Return to the CodePipeline console.
2. Confirm the ```ticket-app-worker-pipeline``` triggers into **In Progress** state right after pushing.
3. Wait until all stages (Source -> Build -> Deploy) show **Succeeded** (green).

![Worker Pipeline Succeeded](/images/5-Workshop/5.8-CICD-Pipeline/pipeline_worker.png)

4. In the Elastic Beanstalk console, verify the health status of ```ticket-app-Worker-env``` shifts to **Ok** (green).
