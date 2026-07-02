---
title : "CI/CD Pipeline cho Worker"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.8.2. </b> "
---

### CI/CD Pipeline cho Worker Server

Chúng ta sẽ thiết lập luồng tích hợp và triển khai tự động cho **Worker Server** (thư mục ```ticket-booking-worker```) lên môi trường Beanstalk ```ticket-app-Worker-env```.

---

#### 1. Thiết lập CI/CD và đẩy mã nguồn Worker

1. **Tạo CodeCommit Repository**:
   * Mở CodeCommit -> Click **Create repository** -> Name: ```ticket-app-worker``` -> click **Create**.

   ![CodeCommit Repository Worker](/images/5-Workshop/5.8-CICD-Pipeline/codecommit_worker.png)

2. **Tạo CodeBuild Project**:
   * Mở CodeBuild -> Click **Create project**:
     * **Project name**: ```ticket-app-worker-build```.
     * **Source**: Provider: **AWS CodeCommit** | Repository: ```ticket-app-worker``` | Branch: ```main```.

     ![CodeBuild Worker Source](/images/5-Workshop/5.8-CICD-Pipeline/codebuild_worker_source.png)

     * **Environment**: Operating system: **Amazon Linux** | Runtime: **Standard** | Image: Chọn bản mới nhất (`aws/codebuild/amazonlinux-x86_64-standard:6.0`).

     ![CodeBuild Worker Environment](/images/5-Workshop/5.8-CICD-Pipeline/codebuild_worker_env.png)

     * **Buildspec**: Nhập nội dung buildspec tương tự (CodeBuild sẽ đóng gói toàn bộ thư mục code worker để deploy lên Beanstalk):
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
     * **Logs**: Chọn CloudWatch logs.

     ![CodeBuild Worker Logs](/images/5-Workshop/5.8-CICD-Pipeline/codebuild_worker_name.png)

     * Click **Create build project**.
3. **Tạo CodePipeline**:
   * Mở CodePipeline -> click **Create pipeline**:
   * **Pipeline settings**:
     * **Pipeline name**: Nhập ```ticket-app-worker-pipeline```.
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

4. **Push code Worker lên CodeCommit**:
   * Mở Terminal tại thư mục Worker ```ticket-booking-worker``` của bạn.
   * **Lưu ý**: Hãy chắc chắn **xóa thư mục ẩn `.git` cũ** (nếu có) trong thư mục này để tránh lỗi xung đột Remote khi chạy `git init`.
   * Khởi tạo Git và thực hiện push code:
     ```bash
     git init
     git branch -M main
     git remote add origin https://git-codecommit.us-east-1.amazonaws.com/v1/repos/ticket-app-worker
     git add .
     git commit -m "Initial commit Worker Server"
     git push -u origin main
     ```
     * *Nhập Username và Password Git CodeCommit khi hệ thống yêu cầu.*

---

#### 2. Kiểm tra trạng thái triển khai

1. Quay lại trang quản lý CodePipeline.
2. Xác nhận Pipeline kích hoạt thành công trạng thái **In Progress** ngay sau khi push code.
3. Đợi cho đến khi các giai đoạn (Source -> Build -> Deploy) hiển thị màu xanh **Succeeded**.

   ![Pipeline Execution History](/images/5-Workshop/5.8-CICD-Pipeline/pipeline_execution_history.png)
   ![CodePipeline Worker Success](/images/5-Workshop/5.8-CICD-Pipeline/pipeline_worker_success.png)

4. Vào Elastic Beanstalk console, xác nhận Health Status của môi trường ```ticket-app-Worker-env``` chuyển sang màu xanh **Ok** với phiên bản ứng dụng vừa được build từ CodeCommit.

   ![EB Worker Deployment Success](/images/5-Workshop/5.8-CICD-Pipeline/eb_worker_deployment_success.png)
