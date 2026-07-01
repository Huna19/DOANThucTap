---
title : "CI/CD Pipeline cho Backend"
date : 2024-01-01
weight : 1
chapter : false
pre : " <b> 5.8.1. </b> "
---

### CI/CD Pipeline cho Backend API Server

Chúng ta sẽ thiết lập luồng tích hợp và triển khai tự động cho **Backend API Server** (thư mục ```ticket-booking-backend```) lên môi trường Beanstalk ```ticket-app-Backend-env```.

---

#### 1. Khởi tạo IAM Role cho EC2 Instance Profile (đã cấu hình ở chương 5.5.2)

Trước khi thao tác với CodeCommit, bạn cần khởi tạo thông tin đăng nhập HTTPS Git hoặc khóa bảo mật cho IAM User:

1. Mở [AWS IAM console](https://us-east-1.console.aws.amazon.com/iam/home#/users).
   
   ![IAM Search](/images/5-Workshop/5.8-CICD-Pipeline/iam_search.png)

2. Click chọn IAM User của bạn -> Chọn tab **Security credentials**.
   
   ![IAM Security Credentials Access Key](/images/5-Workshop/5.8-CICD-Pipeline/iam_user_access_key.png)

3. Cuộn xuống mục **API keys** -> click **Generate API key**.
   
   ![IAM Generate API Key](/images/5-Workshop/5.8-CICD-Pipeline/iam_generate_api_key.png)

4. Trong cửa sổ **Generate API key**, chọn Service là **AWS CodeCommit** và click **Generate API key**.
   
   ![IAM Security Credentials API Keys](/images/5-Workshop/5.8-CICD-Pipeline/iam_user_api_keys.png)

5. Tải tập tin CSV chứa **Username** và **Password** (hoặc thông tin API key) về máy tính và lưu trữ an toàn.

---

#### 2. Thiết lập CI/CD và đẩy mã nguồn Backend

1. Mở [AWS CodeCommit console](https://us-east-1.console.aws.amazon.com/codesuite/codecommit/repositories?region=us-east-1) -> Click **Create repository**.

   ![CodeCommit Repositories](/images/5-Workshop/5.8-CICD-Pipeline/codecommit_repo_btn.png)

   * **Repository name**: Nhập ```ticket-app-backend``` -> click **Create**.

     ![Create CodeCommit Repository](/images/5-Workshop/5.8-CICD-Pipeline/codecommit_repo_create.png)

2. Mở [AWS CodeBuild console](https://us-east-1.console.aws.amazon.com/codesuite/codebuild/projects?region=us-east-1) -> Click **Create project**:

   ![CodeBuild Create Project](/images/5-Workshop/5.8-CICD-Pipeline/codebuild_create.png)

   * **Project name**: ```ticket-app-backend-build```.
   * **Source**: Provider: **AWS CodeCommit** | Repository: ```ticket-app-backend``` | Branch: ```main```.

     ![CodeBuild Backend Source](/images/5-Workshop/5.8-CICD-Pipeline/codebuild_backend_source.png)

   * **Environment**: Operating system: **Amazon Linux** | Runtime: **Standard** | Image: Chọn bản mới nhất (`aws/codebuild/amazonlinux-x86_64-standard:6.0`).

     ![CodeBuild Backend Environment](/images/5-Workshop/5.8-CICD-Pipeline/codebuild_worker_env.png)

   * **Buildspec**: Chọn **Insert build commands** -> Switch to editor và nhập:
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

   * **Logs**: Chọn CloudWatch logs.

     ![CodeBuild Backend Logs](/images/5-Workshop/5.8-CICD-Pipeline/codebuild_backend_logs.png)

   * Click **Create build project**.

3. Mở [AWS CodePipeline console](https://us-east-1.console.aws.amazon.com/codesuite/codepipeline/pipelines?region=us-east-1) -> click **Create pipeline**:
   * **Pipeline name**: ```ticket-app-backend-pipeline``` -> click **Next**.

     ![CodePipeline Backend Settings](/images/5-Workshop/5.8-CICD-Pipeline/pipeline_backend_settings.png)

   * **Source stage**: Source: **AWS CodeCommit** | Repository: ```ticket-app-backend``` | Branch: ```main``` -> click **Next**.

     ![CodePipeline Backend Source Stage](/images/5-Workshop/5.8-CICD-Pipeline/pipeline_backend_source.png)

   * **Build stage**: Build provider: **AWS CodeBuild** | Project name: ```ticket-app-backend-build``` -> click **Next**.

     ![CodePipeline Backend Build Stage](/images/5-Workshop/5.8-CICD-Pipeline/pipeline_build_stage.png)
     ![CodePipeline Backend Build Stage Bottom](/images/5-Workshop/5.8-CICD-Pipeline/pipeline_build_stage_bottom.png)

   * **Deploy stage**: Deploy provider: **AWS Elastic Beanstalk** | Application: ```ticket-app-App``` | Environment: ```ticket-app-Backend-env``` -> click **Next** -> **Create pipeline**.

     ![CodePipeline Backend Deploy Stage](/images/5-Workshop/5.8-CICD-Pipeline/pipeline_backend_deploy.png)

4. Đẩy code Backend lên CodeCommit:
   * Mở Terminal tại thư mục Backend ```ticket-booking-backend``` của bạn.
   * Khởi tạo Git và thực hiện push code:
     ```bash
     git init
     git branch -M main
     git remote add origin https://git-codecommit.us-east-1.amazonaws.com/v1/repos/ticket-app-backend
     git add .
     git commit -m "Initial commit Backend API Server"
     git push -u origin main
     ```
     * *Nhập Username và Password Git CodeCommit đã tải ở phần 1 khi hệ thống yêu cầu.*

   ![Clone CodeCommit Repository](/images/5-Workshop/5.8-CICD-Pipeline/codecommit_clone.png)

---

#### 3. Kiểm tra trạng thái triển khai

1. Quay lại trang quản lý CodePipeline.
2. Xác nhận Pipeline ```ticket-app-backend-pipeline``` kích hoạt thành công trạng thái **In Progress** ngay sau khi push code.
3. Đợi cho đến khi các giai đoạn (Source -> Build -> Deploy) hiển thị màu xanh **Succeeded**.

   ![Backend Pipeline Succeeded](/images/5-Workshop/5.8-CICD-Pipeline/pipeline_backend.png)
   ![Backend Pipeline List](/images/5-Workshop/5.8-CICD-Pipeline/pipeline_backend_list.png)

4. Vào Elastic Beanstalk console, xác nhận Health Status của môi trường ```ticket-app-Backend-env``` chuyển sang màu xanh **Ok** với phiên bản ứng dụng vừa được build từ CodeCommit.

   ![EB Backend Deployment Success](/images/5-Workshop/5.8-CICD-Pipeline/eb_backend_deployment_success.png)
