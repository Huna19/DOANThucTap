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
   * Open CodeCommit -> Click **Create repository** -> Name: ```ticket-app-worker``` -> click **Create**.

     ![CodeCommit Repository Worker](/images/5-Workshop/5.8-CICD-Pipeline/codecommit_worker.png)

2. **Create CodeBuild Project**:
   * Open CodeBuild -> Click **Create project**:
     * **Project name**: ```ticket-app-worker-build```.
     * **Source**: Provider: **AWS CodeCommit** | Repository: ```ticket-app-worker``` | Branch: ```main```.

       ![CodeBuild Worker Source](/images/5-Workshop/5.8-CICD-Pipeline/codebuild_worker_source.png)

     * **Environment**: Operating system: **Amazon Linux** | Runtime: **Standard** | Image: Select latest version (`aws/codebuild/amazonlinux-x86_64-standard:6.0`).

       ![CodeBuild Worker Environment](/images/5-Workshop/5.8-CICD-Pipeline/codebuild_worker_env.png)

     * **Buildspec**: Enter buildspec details (CodeBuild packages all worker code to deploy onto Beanstalk):
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

     * **Logs**: Select CloudWatch logs.

       ![CodeBuild Worker Logs](/images/5-Workshop/5.8-CICD-Pipeline/codebuild_worker_name.png)

     * Click **Create build project**.

3. **Create CodePipeline**:
   * Open CodePipeline -> click **Create pipeline**:
   * **Pipeline settings**:
     * **Pipeline name**: ```ticket-app-worker-pipeline```.
     * Click **Next**.

       ![CodePipeline Worker Settings](/images/5-Workshop/5.8-CICD-Pipeline/pipeline_worker_settings.png)

   * **Source stage**: 
     * Source provider: **AWS CodeCommit**
     * Repository name: ```ticket-app-worker```
     * Branch name: ```main``` 
     * Click **Next**.

       ![CodePipeline Worker Source](/images/5-Workshop/5.8-CICD-Pipeline/pipeline_worker_source.png)

   * **Build stage**: Build provider: **AWS CodeBuild** | Project name: ```ticket-app-worker-build``` -> click **Next**.

     ![CodePipeline Worker Build Stage](/images/5-Workshop/5.8-CICD-Pipeline/pipeline_build_stage.png)
     ![CodePipeline Worker Build Stage Bottom](/images/5-Workshop/5.8-CICD-Pipeline/pipeline_build_stage_bottom.png)

   * **Deploy stage**: 
     * Deploy provider: **AWS Elastic Beanstalk**
     * Application name: ```ticket-app-App``` 
     * Environment name: ```ticket-app-worker-env```
     * Click **Next** -> Click **Create pipeline**.

       ![CodePipeline Worker Deploy](/images/5-Workshop/5.8-CICD-Pipeline/pipeline_worker_deploy.png)
       ![CodePipeline Worker Create](/images/5-Workshop/5.8-CICD-Pipeline/pipeline_worker_create_btn.png)

4. **Push Worker Code to CodeCommit**:
   * Open a Terminal in your Worker directory ```ticket-booking-worker```.
   * **Note**: Make sure to **delete the old hidden `.git` folder** (if exists) in this directory to avoid Remote configuration conflicts when running git init.
   * Initialize Git and push:
     ```bash
     git init
     git branch -M main
     git remote add origin https://git-codecommit.us-east-1.amazonaws.com/v1/repos/ticket-app-worker
     git add .
     git commit -m "Initial commit Worker Server"
     git push -u origin main
     ```
     * *Enter the Username and Password Git CodeCommit when prompted.*

---

#### 2. Verify Deployment

1. Return to the CodePipeline console.
2. Confirm the ```ticket-app-worker-pipeline``` triggers into **In Progress** state right after pushing.
3. Wait until all stages (Source -> Build -> Deploy) show **Succeeded** (green).

   ![Pipeline Execution History](/images/5-Workshop/5.8-CICD-Pipeline/pipeline_execution_history.png)
   ![CodePipeline Worker Success](/images/5-Workshop/5.8-CICD-Pipeline/pipeline_worker_success.png)

4. In the Elastic Beanstalk console, verify the health status of ```ticket-app-Worker-env``` shifts to **Ok** (green) with the application version built from CodeCommit.

   ![EB Worker Deployment Success](/images/5-Workshop/5.8-CICD-Pipeline/eb_worker_deployment_success.png)
