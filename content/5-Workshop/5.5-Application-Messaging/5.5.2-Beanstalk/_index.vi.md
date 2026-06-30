---
title : "Triển khai Beanstalk Backend & Worker"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.5.2. </b> "
---

### Triển khai máy chủ Elastic Beanstalk

Trong phần này, chúng ta sẽ triển khai máy chủ API Backend và máy chủ Worker ngầm bằng **AWS Elastic Beanstalk** và cấu hình các biến môi trường để hệ thống hoạt động.

---

#### 1. Khởi tạo IAM Role cho EC2 Instance Profile

Elastic Beanstalk cần một IAM Role (Instance Profile) để cấp quyền cho các máy chủ EC2 giao tiếp với các dịch vụ khác (SQS, S3, RDS, SES).

1. Mở **IAM Console** -> chọn **Roles** -> click **Create role**.
2. Chọn **Trusted entity type**: **AWS service**.
3. Chọn **Use case**: **EC2** -> click **Next**.

   ![EB IAM Trusted Entity](/images/5-Workshop/5.5-Application-Messaging/eb_iam_trusted_entity.png)

4. Tìm và tick chọn các **Managed Policies** sau:
   * `AWSElasticBeanstalkWebTier`
   * `AWSElasticBeanstalkWorkerTier`
   * `AWSElasticBeanstalkMulticontainerDocker`
5. Click **Next** -> Nhập **Role name**: `ticket-app-beanstalk-ec2-role`.
6. Click **Create role**.

   ![IAM Create Role](/images/5-Workshop/5.5-Application-Messaging/iam_create_role_btn.png)
7. Mở role `ticket-app-beanstalk-ec2-role` vừa tạo, chọn tab **Permissions** -> click **Add permissions** -> **Create inline policy**.

   ![EB IAM Add Inline Policy](/images/5-Workshop/5.5-Application-Messaging/eb_iam_add_inline_policy.png)

8. Thêm các quyền truy cập vào SQS, SES, SNS, S3 và Secrets Manager. (Bạn có thể cấp FullAccess cho các dịch vụ này nếu đang trong môi trường Lab để tiết kiệm thời gian, hoặc sử dụng mã JSON Policy chuẩn).
9. Lưu Inline Policy lại với tên `ticket-app-beanstalk-inline-policy`.

   ![EB IAM Inline Policy](/images/5-Workshop/5.5-Application-Messaging/eb_iam_inline_policy.png)

---

#### 2. Triển khai Beanstalk Backend (Web Server Environment)

**Bước 1.1: Tạo Application**
1. Mở [AWS Elastic Beanstalk console](https://us-east-1.console.aws.amazon.com/elasticbeanstalk/home?region=us-east-1#/applications).
2. Click **Create application** (trên trang Applications).
3. Nhập **Application name**: ```ticket-app-App``` và click **Create**.

![EB Create Application](/images/5-Workshop/5.5-Application-Messaging/eb_create_app.png)

**Bước 1.2: Tạo Environment (Backend)**
1. Trong màn hình quản lý Application ```ticket-app-App```, click **Create a new environment**.
2. **Environment tier**: Chọn **Web server environment**.
3. **Environment name**: Nhập ```ticket-app-Backend-env```.
4. **Platform**: Chọn **Node.js** và **Platform branch** là **Node.js 20 running on 64bit Amazon Linux 2023**.
5. **Application code**: Chọn **Sample application**.
6. Click **Next**.

![EB Create Environment](/images/5-Workshop/5.5-Application-Messaging/eb_create_env.png)
![EB Platform](/images/5-Workshop/5.5-Application-Messaging/eb_platform.png)

7. Cấu hình **Service Access**:
   * **Service role**: Chọn **Use an existing service role** (chọn role mặc định của Beanstalk) hoặc để hệ thống tự tạo mới.
   * **EC2 instance profile**: Chọn `ticket-app-beanstalk-ec2-role` vừa tạo ở Bước 1.
   * Click **Next**.

![EB Service Access](/images/5-Workshop/5.5-Application-Messaging/eb_service_access.jpg)
8. Cấu hình **Networking** (Step 3 - Set up networking):
   * **VPC**: Chọn VPC ```ticket-app-vpc```.
   * **Public IP address**: Chọn **Disabled**.
   * **Instance subnets**: Tích chọn hai **Private Subnets** (`ticket-app-subnet-private-a` và `ticket-app-subnet-private-b`).
   * Click **Next**.

![EB Instance Subnets](/images/5-Workshop/5.5-Application-Messaging/eb_instance_subnets.jpg)
9. Cấu hình **Instance traffic and scaling** (Step 4):
   * **EC2 security groups**: Chọn Security Group `ticket-app-ec2-worker-sg` để EC2 giao tiếp được với RDS và Redis.
   * Kéo xuống phần **Capacity** -> **Auto scaling group**:
     * **Environment type**: Chọn **Load balanced**.
     * **Min instances**: `2`, **Max instances**: `4`.
     * **Scaling triggers**: Metric chọn ```CPUUtilization``` (Upper: ```70%```, Lower: ```30%```).

![EB Security and Scaling](/images/5-Workshop/5.5-Application-Messaging/eb_security_scaling.jpg)

10. Vẫn ở Step 4, kéo xuống phần **Load balancer network settings**:
   * **Visibility**: Chọn **Public**.
   * **Load balancer subnets**: Tích chọn hai **Public Subnets** (`ticket-app-subnet-public-a` và `ticket-app-subnet-public-b`).

![EB Load Balancer Subnets](/images/5-Workshop/5.5-Application-Messaging/eb_lb_subnets.jpg)

11. Cấu hình **Load balancer network and security** (Tiếp tục trong màn hình Load balancer):
   * Tại mục **Load balancer security groups**, chọn `ticket-app-alb-sg`.
   * Ở mục **Processes**, tick chọn process mặc định (thường là `default`), click **Actions -> Edit**.
   * Sửa **Health check path** từ `/` thành `/health`. Click **Save**.
   * Bỏ qua các cấu hình còn lại bằng cách click **Next** đến màn hình cuối cùng, click **Submit** để khởi tạo môi trường.

![EB Application and Environment](/images/5-Workshop/5.5-Application-Messaging/beanstalk_environments.png)

---

#### 3. Triển khai Beanstalk Worker (Web Server Environment)

{{% notice important %}}
Lưu ý quan trọng: Beanstalk Worker Environment trong dự án này thực chất là một tiến trình Node.js chủ động pull tin nhắn từ SQS qua SDK. Do đó, chúng ta vẫn triển khai nó dưới dạng **Web server environment** (Load balanced) tương tự Backend chứ không dùng loại Worker Environment đặc thù của Beanstalk.
{{% /notice %}}

1. Quay lại trang ứng dụng Elastic Beanstalk ```ticket-app-App```.
2. Click **Create new environment** (góc trên bên phải).
3. **Environment tier**: Chọn **Web server environment**.
4. **Environment name**: Đặt tên ```ticket-app-Worker-env```.
5. Platform cấu hình tương tự Node.js 20.
6. Cấu hình **Service Access** và **Networking** giống với Backend ở trên.
7. Cấu hình **Instances**, **Capacity**, và **Load balancer**:
   * **EC2 security groups**: Chọn `ticket-app-ec2-worker-sg`.
   * **Load balancer security groups**: Chọn `ticket-app-alb-sg`.
   * **Processes Health check path**: Đổi thành `/health`.
8. Click **Submit** để khởi tạo môi trường.

---

#### 4. Cấu hình Environment Properties (Biến môi trường) trên Beanstalk

Để cả Backend và Worker có thể hoạt động và kết nối được với Database, Cache, SQS, và Cognito, bạn cần cấu hình các biến môi trường trực tiếp trên Beanstalk Console cho từng môi trường:

1. **Cấu hình cho Backend (```ticket-app-Backend-env```)**:
   * Vào chi tiết môi trường ```ticket-app-Backend-env``` -> chọn **Configuration** ở menu trái.
   * Tìm mục **Updates, monitoring, and logging** -> click **Edit**.
   * Cuộn xuống mục **Environment properties** ở cuối trang và nhập các biến sau:
     * ```PORT```: ```8080```
     * ```AWS_REGION```: ```us-east-1```
     * ```DB_HOST```: *(Nhập Proxy endpoint của RDS Proxy - xem chương 5.6)*
     * ```DB_PORT```: ```5432```
     * ```DB_NAME```: ```ticketing_db```
     * ```DB_USER```: ```postgres```
     * ```DB_PASSWORD```: ```TicketingAppPassword2026!```
     * ```REDIS_HOST```: *(Nhập Primary endpoint của Redis - xem chương 5.6)*
     * ```REDIS_PORT```: ```6379```
     * ```SQS_BOOKING_QUEUE_URL```: ```https://sqs.us-east-1.amazonaws.com/<your-account-id>/booking-queue.fifo```
     * ```COGNITO_USER_POOL_ID```: *(Xem chương 5.7)*
     * ```COGNITO_CLIENT_ID```: *(Xem chương 5.7)*
     * ```CLOUDFRONT_DOMAIN```: ```https://<your-cloudfront-domain>.cloudfront.net```
     * ```MOMO_PARTNER_CODE```: ```MOMO```
     * ```MOMO_ACCESS_KEY```: ```F8BBA842ECF85```
     * ```MOMO_SECRET_KEY```: ```K951B6PE1waDMi640xX08PD3vg6EkVlz```
     * ```MOMO_ENDPOINT```: ```https://test-payment.momo.vn/v2/gateway/api```
     * ```S3_BUCKET_NAME```: ```ticket-app-assets-<your-account-id>```
     * ```S3_REGION```: ```us-east-1```
     * ```SNS_OPS_TOPIC_ARN```: *(ARN của OpsNotificationTopic)*
     * ```SNS_USER_TOPIC_ARN```: *(ARN của UserNotificationTopic)*
     * ```MOMO_IPN_URL```: ```https://<apigw-domain>/api/payments/momo/ipn```
     * ```MOMO_REDIRECT_URL```: ```https://<cloudfront-domain>/payment/result```
     * ```RESERVATION_TIMEOUT_MINUTES```: ```15```
   * Click **Apply** và đợi môi trường cập nhật lại cấu hình.

![Backend Environment Properties](/images/5-Workshop/5.5-Application-Messaging/backend_properties.png)

2. **Cấu hình cho Worker (```ticket-app-Worker-env```)**:
   * Tương tự Backend, vào mục **Environment properties** của Worker và nhập các biến:
     * *(Sao chép toàn bộ các biến cấu hình kết nối DB, Redis, SQS, S3, SNS tương tự như Backend).*
     * ```WORKER_CONCURRENCY```: ```5```
     * ```VISIBILITY_TIMEOUT_SECONDS```: ```60```
     * ```POLL_WAIT_TIME_SECONDS```: ```20```
     * ```SMTP_HOST```: ```email-smtp.us-east-1.amazonaws.com```
     * ```SMTP_PORT```: ```587```
     * ```SMTP_USERNAME```: *(Tài khoản SMTP của SES)*
     * ```SMTP_PASSWORD```: *(Mật khẩu SMTP của SES)*
     * ```MAIL_FROM```: *(Email đã verify trong SES)*
     * ```MAIL_FROM_NAME```: ```Ticket Booking```
   * Click **Apply** và đợi môi trường cập nhật lại cấu hình.

![Worker Environment Properties](/images/5-Workshop/5.5-Application-Messaging/worker_properties.png)
