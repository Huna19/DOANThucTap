---
title : "Dọn dẹp tài nguyên"
date : 2024-01-01
weight : 9
chapter : false
pre : " <b> 5.9. </b> "
---

### Dọn dẹp tài nguyên (Resource Cleanup)

{{% notice warning %}}
Để tránh phát sinh các chi phí ngoài ý muốn trên tài khoản AWS cá nhân của bạn, hãy thực hiện dọn dẹp toàn bộ tài nguyên ngay sau khi hoàn thành bài lab thực hành.
{{% /notice %}}

Vui lòng chọn phương án dọn dẹp phù hợp với phương thức triển khai bạn đã sử dụng ở chương **5.2**:

*   **Trường hợp A: Nếu bạn triển khai bằng CloudFormation (Lựa chọn A ở chương 5.2)**
    *   Bạn **KHÔNG ĐƯỢC** xóa thủ công từng tài nguyên riêng lẻ trước. Việc xóa thủ công sẽ phá vỡ trạng thái liên kết của CloudFormation Stack, dẫn đến lỗi Stack bị treo hoặc báo lỗi `DELETE_FAILED` khi xóa.
    *   Hãy cuộn xuống và thực hiện trực tiếp **Mục 2. Hướng dẫn Dọn dẹp bằng CloudFormation**.
*   **Trường hợp B: Nếu bạn tự tạo tài nguyên thủ công (Lựa chọn B ở chương 5.2)**
    *   Hãy làm theo hướng dẫn tại **Mục 1. Dọn dẹp thủ công từng tài nguyên**.

---

#### 1. Dọn dẹp thủ công từng tài nguyên (Dành cho Lựa chọn B)

Thực hiện xóa các tài nguyên theo trình tự từ trên xuống dưới:

1. **Xóa môi trường Elastic Beanstalk**:
   * Mở [Elastic Beanstalk console](https://us-east-1.console.aws.amazon.com/elasticbeanstalk/home?region=us-east-1#/environments).
   * Chọn môi trường ```ticket-app-Backend-env``` -> click **Actions** -> chọn **Terminate environment**.
   * Thực hiện tương tự để Terminate môi trường ```ticket-app-Worker-env```.
   * Chờ cho đến khi quá trình hủy môi trường hoàn tất, sau đó xóa Application: Quay lại trang **Applications** -> chọn ```ticket-app-App``` -> click **Actions** -> **Delete application**.

2. **Xóa API Gateway**:
   * Mở [API Gateway console](https://us-east-1.console.aws.amazon.com/apigateway/main/apis?region=us-east-1).
   * Chọn HTTP API của bạn (ví dụ: `TicketAppAPI`) -> click **Delete** -> Xác nhận xóa.

3. **Xóa CloudFront Distribution**:
   * Mở [CloudFront console](https://us-east-1.console.aws.amazon.com/cloudfront/v3/home?region=us-east-1#/distributions).
   * Chọn Distribution của bạn -> click **Disable**. Quá trình này sẽ mất vài phút.
   * Sau khi trạng thái chuyển sang Disabled, chọn lại Distribution -> click **Delete**.

4. **Xóa RDS Proxy & RDS PostgreSQL**:
   * Mở [Amazon RDS console](https://us-east-1.console.aws.amazon.com/rds/home?region=us-east-1#databases:).
   * Chọn **Proxies** -> Chọn ```rds-proxy-ticket-app``` -> click **Actions** -> **Delete**.
   * Chọn **Databases** -> Chọn Database instance ```database-ticket-app``` -> click **Actions** -> **Delete**:
     * Chọn **No** ở mục tạo final snapshot (để xóa nhanh không cần sao lưu).
     * Tích chọn xác nhận và nhập ```delete me``` để đồng ý xóa.

5. **Xóa ElastiCache Redis replication group**:
   * Mở [ElastiCache console](https://us-east-1.console.aws.amazon.com/elasticache/home?region=us-east-1#/clusters).
   * Chọn cụm Redis ```ticket-app-redis``` -> click **Actions** -> **Delete**.

6. **Xóa Cognito User Pool**:
   * Mở [Amazon Cognito console](https://us-east-1.console.aws.amazon.com/cognito/v2/home?region=us-east-1#).
   * Chọn User Pool ```ticket-app-user-pool``` -> click **Delete user pool**.

7. **Xóa AWS CodePipeline, CodeBuild & CodeCommit**:
   * Mở **CodePipeline console**:
     * Chọn các pipeline ```ticket-app-backend-pipeline``` và ```ticket-app-worker-pipeline``` -> click **Delete**.
   * Mở **CodeBuild console**:
     * Chọn các project ```ticket-app-backend-build``` và ```ticket-app-worker-build``` -> click **Delete**.
   * Mở **CodeCommit console**:
     * Chọn các repository ```ticket-app-backend``` và ```ticket-app-worker``` -> click **Delete**.

8. **Xóa Amazon SQS, SNS & CloudWatch Alarm**:
   * Mở **CloudWatch console** -> **Alarms**: Chọn Alarm `ticket-app-checkout-dlq-alarm` -> click **Delete**.
   * Mở **Amazon SQS console**: Chọn `booking-queue.fifo` và `checkout-dlq.fifo` -> click **Delete**.
   * Mở **Amazon SNS console**: Chọn các Topic (`booking-notification-topic` và `booking-notification-topic-for-user`) -> click **Delete**.

9. **Xóa SES Identity & SMTP Credentials**:
   * Mở **Amazon SES console**: Chọn **Identities** -> Chọn Email của bạn -> click **Delete**.
   * Mở **IAM console**: Chọn **Users** -> Chọn User `ticket-app-smtp-user` -> click **Delete**.

10. **Xóa Secrets Manager**:
    * Mở [Secrets Manager console](https://us-east-1.console.aws.amazon.com/secretsmanager/home?region=us-east-1#!/listSecrets).
    * Chọn secret của bạn (chứa mật khẩu DB) -> click **Actions** -> **Delete secret**. (Nhập số ngày chờ là 7 ngày).

11. **Xóa S3 Buckets**:
    * Mở [Amazon S3 console](https://s3.console.aws.amazon.com/s3/home?region=us-east-1#).
    * Bạn phải **Empty** (xóa sạch file) trong bucket trước khi có thể xóa bucket:
      * Chọn Frontend Bucket ```frontend-ticket-app-app-<your-account-id>``` -> click **Empty** -> nhập `permanently delete` để xác nhận.
      * Thực hiện tương tự với Assets Bucket ```ticket-app-assets-<your-account-id>```.
      * Sau khi empty xong, chọn các Bucket -> click **Delete** -> nhập tên bucket để xác nhận xóa hẳn.

12. **Xóa Hạ tầng Mạng (VPC, NAT, IGW, SGs)**:
    * Mở [VPC console](https://us-east-1.console.aws.amazon.com/vpc/home?region=us-east-1).
    * **NAT Gateways**: Xóa 2 NAT Gateways. (Quá trình xóa sẽ mất vài phút).
    * **Elastic IPs**: Release 2 EIPs đã liên kết với NAT.
    * **VPC**: Chọn VPC `ticket-app-vpc` -> click **Actions** -> **Delete VPC**. Tính năng này sẽ tự động xóa các Subnets, Route Tables, Internet Gateway và Security Groups đi kèm (nếu không còn tài nguyên nào phụ thuộc). Hãy đảm bảo tất cả các tài nguyên ở trên (EC2, RDS, ElastiCache, Beanstalk, ELB) đã được xóa hoàn toàn trước khi thực hiện bước này.

---

#### 2. Hướng dẫn Dọn dẹp bằng CloudFormation (Dành cho Lựa chọn A)

Nếu bạn deploy toàn bộ hạ tầng thông qua file template CloudFormation ở chương 5.2:

1. Mở [AWS CloudFormation console](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks).
2. Chọn Stack của bạn (ví dụ: `ticket-app-stack`).
3. Click **Delete** ở thanh công cụ phía trên.
4. Xác nhận **Delete stack**.

5. Hệ thống sẽ tự động giải phóng toàn bộ tài nguyên mạng và máy chủ (VPC, Subnets, NAT Gateways, Beanstalk, RDS, Redis, S3, Cognito...) một cách an toàn và sạch sẽ mà không cần phải thực hiện dọn dẹp thủ công từng bước.
