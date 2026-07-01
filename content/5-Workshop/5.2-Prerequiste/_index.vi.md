---
title : "Các bước chuẩn bị"
date : 2024-01-01 
weight : 2
chapter : false
pre : " <b> 5.2. </b> "
---

### Các bước chuẩn bị (Prerequisites)

Để hoàn thành bài thực hành workshop xây dựng ứng dụng đặt vé sự kiện **Ticket-App**, bạn cần chuẩn bị môi trường phát triển cục bộ và phân quyền tài khoản AWS tương ứng.

---

#### 1. Quyền hạn IAM (IAM Permissions)

Bạn cần sử dụng một tài khoản IAM User hoặc IAM Role có các quyền hạn để dọn dẹp và vận hành các tài nguyên trong workshop. 

{{% notice note %}}
Để thực hành lab cá nhân một cách thuận tiện nhất và tránh lỗi phân quyền (Access Denied), chúng tôi khuyên bạn nên sử dụng quyền **AdministratorAccess** cho tài khoản thực hành của mình.
{{% /notice %}}

Nếu bạn muốn cấu hình chính sách phân quyền tối thiểu (Least Privilege), hãy làm theo các bước sau để tạo IAM Policy trên AWS Console:

1. Đăng nhập vào **AWS Management Console** và tìm kiếm dịch vụ **IAM**.
2. Chọn **Policies** ở thanh điều hướng bên trái và nhấn **Create policy**.
3. Tại giao diện tạo policy, chuyển sang trình chỉnh sửa **JSON** (JSON editor), xóa hết mã mẫu cũ và dán đoạn chính sách JSON dưới đây vào:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ElasticBeanstalkCleanup",
      "Effect": "Allow",
      "Action": [
        "elasticbeanstalk:TerminateEnvironment",
        "elasticbeanstalk:DeleteApplication",
        "elasticbeanstalk:DeleteApplicationVersion",
        "elasticbeanstalk:DeleteConfigurationTemplate"
      ],
      "Resource": "*"
    },
    {
      "Sid": "EC2AndAutoScalingCleanup",
      "Effect": "Allow",
      "Action": [
        "ec2:TerminateInstances",
        "ec2:DeleteSecurityGroup",
        "ec2:DeleteSubnet",
        "ec2:DeleteVpc",
        "ec2:DeleteInternetGateway",
        "ec2:DetachInternetGateway",
        "ec2:DeleteNatGateway",
        "ec2:DeleteRouteTable",
        "ec2:DeleteRoute",
        "ec2:DisassociateRouteTable",
        "ec2:ReleaseAddress",
        "ec2:DeleteVpcEndpoints",
        "ec2:DescribeInstances",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs",
        "ec2:DescribeSubnets",
        "ec2:DescribeInternetGateways",
        "ec2:DescribeNatGateways",
        "ec2:DescribeRouteTables",
        "ec2:DescribeAddresses",
        "ec2:DescribeVpcEndpoints",
        "ec2:DescribeNetworkInterfaces",
        "autoscaling:DeleteAutoScalingGroup",
        "autoscaling:UpdateAutoScalingGroup",
        "autoscaling:DeleteLaunchConfiguration",
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeLaunchConfigurations"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "aws:RequestedRegion": "us-east-1"
        }
      }
    },
    {
      "Sid": "RDSCleanup",
      "Effect": "Allow",
      "Action": [
        "rds:DeleteDBInstance",
        "rds:DeleteDBProxy",
        "rds:DeregisterDBProxyTargets",
        "rds:DeleteDBSubnetGroup",
        "rds:DescribeDBInstances",
        "rds:DescribeDBProxies",
        "rds:DescribeDBSubnetGroups"
      ],
      "Resource": "*"
    },
    {
      "Sid": "ElastiCacheCleanup",
      "Effect": "Allow",
      "Action": [
        "elasticache:DeleteReplicationGroup",
        "elasticache:DeleteCacheSubnetGroup",
        "elasticache:DescribeReplicationGroups",
        "elasticache:DescribeCacheSubnetGroups"
      ],
      "Resource": "*"
    },
    {
      "Sid": "SQSCleanup",
      "Effect": "Allow",
      "Action": [
        "sqs:DeleteQueue",
        "sqs:GetQueueUrl",
        "sqs:ListQueues"
      ],
      "Resource": "*"
    },
    {
      "Sid": "SNSCleanup",
      "Effect": "Allow",
      "Action": [
        "sns:DeleteTopic",
        "sns:ListTopics"
      ],
      "Resource": "*"
    },
    {
      "Sid": "CognitoCleanup",
      "Effect": "Allow",
      "Action": [
        "cognito-idp:DeleteUserPool",
        "cognito-idp:DescribeUserPool"
      ],
      "Resource": "*"
    },
    {
      "Sid": "S3Cleanup",
      "Effect": "Allow",
      "Action": [
        "s3:DeleteBucket",
        "s3:DeleteObject",
        "s3:DeleteObjectVersion",
        "s3:ListBucket",
        "s3:ListBucketVersions",
        "s3:GetBucketLocation"
      ],
      "Resource": "*"
    },
    {
      "Sid": "APIGatewayCleanup",
      "Effect": "Allow",
      "Action": [
        "apigateway:DELETE",
        "apigateway:GET"
      ],
      "Resource": "*"
    },
    {
      "Sid": "CloudFrontCleanup",
      "Effect": "Allow",
      "Action": [
        "cloudfront:DeleteDistribution",
        "cloudfront:GetDistribution",
        "cloudfront:UpdateDistribution"
      ],
      "Resource": "*"
    },
    {
      "Sid": "CodePipelineCleanup",
      "Effect": "Allow",
      "Action": [
        "codepipeline:DeletePipeline",
        "codepipeline:GetPipeline"
      ],
      "Resource": "*"
    },
    {
      "Sid": "CodeBuildCleanup",
      "Effect": "Allow",
      "Action": [
        "codebuild:DeleteProject",
        "codebuild:BatchGetProjects"
      ],
      "Resource": "*"
    },
    {
      "Sid": "CodeCommitCleanup",
      "Effect": "Allow",
      "Action": [
        "codecommit:DeleteRepository",
        "codecommit:GetRepository"
      ],
      "Resource": "*"
    },
    {
      "Sid": "SecretsManagerCleanup",
      "Effect": "Allow",
      "Action": [
        "secretsmanager:DeleteSecret",
        "secretsmanager:ListSecrets"
      ],
      "Resource": "*"
    },
    {
      "Sid": "CloudWatchCleanup",
      "Effect": "Allow",
      "Action": [
        "cloudwatch:DeleteAlarms",
        "cloudwatch:DescribeAlarms",
        "logs:DeleteLogGroup",
        "logs:DescribeLogGroups"
      ],
      "Resource": "*"
    },
    {
      "Sid": "IAMCleanup",
      "Effect": "Allow",
      "Action": [
        "iam:DeleteRole",
        "iam:DeleteRolePolicy",
        "iam:DeleteInstanceProfile",
        "iam:RemoveRoleFromInstanceProfile",
        "iam:DetachRolePolicy",
        "iam:ListRolePolicies",
        "iam:ListAttachedRolePolicies",
        "iam:GetRole",
        "iam:GetInstanceProfile"
      ],
      "Resource": "*"
    },
    {
      "Sid": "ELBCleanup",
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:DeleteLoadBalancer",
        "elasticloadbalancing:DeleteTargetGroup",
        "elasticloadbalancing:DescribeLoadBalancers",
        "elasticloadbalancing:DescribeTargetGroups"
      ],
      "Resource": "*"
    },
    {
      "Sid": "KMSDescribe",
      "Effect": "Allow",
      "Action": [
        "kms:DescribeKey",
        "kms:ListKeys"
      ],
      "Resource": "arn:aws:kms:us-east-1:<your-account-id>:key/*"
    }
  ]
}
```

5. Nhấn **Next**.
6. Nhập tên cho chính sách (ví dụ: `TicketAppCleanupPolicy`), thêm mô tả tùy chọn, và nhấn **Create policy**.
7. Tiến hành gán chính sách này vào **IAM User** của bạn (truy cập menu **Users** -> chọn User của bạn -> **Add permissions** -> **Attach policies directly** và chọn chính sách `TicketAppCleanupPolicy` vừa tạo).

![Tạo IAM Policy](/images/5-Workshop/5.2-Prerequiste/iam_policy.png)

---

#### 2. Cài đặt môi trường phát triển cục bộ (Local Workspace Setup)

Hãy đảm bảo máy trạm của bạn đã được cài đặt sẵn các công cụ sau:

##### A. Node.js & npm
*   Ứng dụng Ticket-App được viết bằng Node.js. Bạn cần cài đặt Node.js phiên bản **18.x** hoặc **20.x** (LTS).
*   Kiểm tra cài đặt:
    ```bash
    node -v
    npm -v
    ```

##### B. Git
*   Sử dụng Git để tải mã nguồn dự án.
*   Kiểm tra cài đặt:
    ```bash
    git --version
    ```

##### C. AWS CLI & Configure
*   Cài đặt công cụ dòng lệnh AWS CLI để tương tác với tài khoản AWS.
*   Sau khi cài đặt, chạy lệnh sau để cấu hình thông tin xác thực (Access Key & Secret Key) của IAM User đã được phân quyền:
    ```bash
    aws configure
    ```
    *   *Default region name:* `us-east-1` (N. Virginia)
    *   *Default output format:* `json`

---

#### 3. Tải mã nguồn dự án (Project Source Code)

Mã nguồn của ứng dụng Ticket-App được chia làm 3 thư mục chính:
1.  **ticket-booking-frontend/**: Giao diện React tĩnh hiển thị danh sách sự kiện và đặt vé.
2.  **ticket-booking-backend/** (Backend API): Mã nguồn Node.js API (Express) xử lý tiếp nhận lượt booking, xác thực Cognito và đẩy tin nhắn vào SQS.
3.  **ticket-booking-worker/** (Worker): Mã nguồn chạy tác vụ ngầm tiêu thụ SQS để ghi nhận thông tin đặt vé vào PostgreSQL DB.

Hãy clone dự án từ repository workshop của bạn:
```bash
git clone https://github.com/free-cloud-journey/ticket-app-workshop.git
cd ticket-app-workshop
```

![Tải mã nguồn](/images/5-Workshop/5.2-Prerequiste/git_clone.png)

---

#### 4. Lựa chọn Phương thức Triển khai Hạ tầng (VPC, RDS, Beanstalk, SQS,...)

Trong workshop này, bạn có thể lựa chọn 1 trong 2 phương thức sau để xây dựng cơ sở hạ tầng mạng và máy chủ:

*   **Lựa chọn A (Khuyên dùng - Nhanh chóng): Triển khai tự động bằng AWS CloudFormation**
    *   Hạ tầng sẽ được khởi tạo hoàn toàn tự động chỉ sau 15-20 phút.
    *   Các chương từ **5.3 đến 5.7** sẽ đóng vai trò là hướng dẫn để bạn **Kiểm tra và Xác thực** cấu hình tài nguyên đã được tạo thay vì phải tự tạo lại.
*   **Lựa chọn B: Tự tay cấu hình thủ công từng bước (Manual)**
    *   Bạn sẽ **bỏ qua** bước 4 (chạy CloudFormation) dưới đây.
    *   Bắt đầu từ chương **5.3**, bạn sẽ tự tay làm theo từng bước hướng dẫn trên AWS Console để tự xây dựng hệ thống từ con số 0.

---

#### Hướng dẫn cho Lựa chọn A: Triển khai tự động bằng CloudFormation

Toàn bộ hạ tầng cốt lõi của ứng dụng (VPC, RDS, Redis, Beanstalk, SQS, Cognito, API Gateway, CloudFront, CI/CD Pipeline) sẽ được triển khai tự động thông qua file CloudFormation template ```template.yaml```.

1. Mở [AWS CloudFormation console](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks).
2. Click **Create stack** -> chọn **With new resources (standard)**.
3. Tại giao diện **Prerequisite - Prepare template**, chọn **Template is ready**:
   * **Template source**: Chọn **Upload a template file**.
   * Click **Choose file** và tải lên tệp tin ```template.yaml``` trong thư mục dự án của bạn.
   * Click **Next**.

4. Tại giao diện **Specify stack details**:
   * **Stack name**: Nhập ```ticket-app-stack```.
   * **Parameters**:
     * **EnvironmentName**: Nhập ```ticket-app```.
     * **DBMasterUsername**: ```postgres```.
     * **DBName**: ```ticketing_db``` (Lưu ý sử dụng đồng bộ tên Database này xuyên suốt bài lab).
     * Giữ nguyên các tham số mặc định khác.
   * Click **Next**.

5. Tại giao diện **Configure stack options**, giữ nguyên cấu hình mặc định và click **Next**.
6. Tại giao diện **Review ticket-app-stack**:
   * Cuộn xuống cuối trang, tích chọn **I acknowledge that AWS CloudFormation might create IAM resources with custom names.** (Xác nhận cấp quyền cho CloudFormation tạo các IAM Roles).
   * Click **Submit** để bắt đầu triển khai.

7. Quá trình triển khai sẽ mất khoảng **15 - 20 phút** để khởi tạo toàn bộ tài nguyên (đặc biệt là RDS Multi-AZ, CloudFront CDN và Beanstalk Environments). Hãy đợi cho đến khi trạng thái chuyển sang **CREATE_COMPLETE**.

Sau khi CloudFormation Stack triển khai thành công, hạ tầng cơ bản của bạn đã hoàn thành! Ở các chương tiếp theo, nếu đi theo **Lựa chọn A**, bạn chỉ cần đi qua các dịch vụ để **xác minh và kiểm tra** cấu hình, sau đó tiến hành các bước deploy source code.
