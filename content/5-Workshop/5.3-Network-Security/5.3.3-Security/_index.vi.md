---
title : "Bảo mật & Security Groups"
date : 2024-01-01
weight : 3
chapter : false
pre : " <b> 5.3.3. </b> "
---

### Bảo mật & Security Groups

Trong phần này, chúng ta sẽ cấu hình lưu trữ mật khẩu an toàn bằng Secrets Manager và thiết lập hệ thống tường lửa Security Groups cho các tài nguyên.

---

#### 1. Tạo AWS Secrets Manager lưu DB Credentials

{{% notice info %}}
Chúng ta sử dụng AWS Secrets Manager để lưu trữ thông tin đăng nhập Database tập trung. Các máy chủ Backend sẽ tự động lấy credentials từ đây khi chạy, đảm bảo không lưu trữ mật khẩu tĩnh trong mã nguồn.
{{% /notice %}}

1. Mở [AWS Secrets Manager console](https://us-east-1.console.aws.amazon.com/secretsmanager/home?region=us-east-1#/listSecrets).
2. Click **Store a new secret**.
3. Chọn loại secret: **Credentials for Amazon RDS database** hoặc **Other type of secret**:
   * Nhập Key/Value:
     * Key: ```username``` | Value: ```postgres```
     * Key: ```password``` | Value: Nhập mật khẩu bí mật của bạn (ví dụ: ```TicketingAppPassword2026!```).

![Secrets KV](/images/5-Workshop/5.3-Network-Security/secrets_create_kv.png)

4. Click **Next**.
5. Cấu hình thông tin Secret:
   * **Secret name**: Nhập ```ticket-app/rds/credentials```.

![Secrets Name](/images/5-Workshop/5.3-Network-Security/secrets_create_name.png)

6. Click **Next** -> Giữ nguyên cấu hình xoay vòng (rotation) mặc định -> click **Store** để lưu trữ.

![Secrets Manager Complete](/images/5-Workshop/5.3-Network-Security/secrets_complete.png)

---

#### 2. Khởi tạo và Cấu hình Security Groups

Nhóm bảo mật (Security Group) hoạt động như một tường lửa ảo kiểm soát lưu lượng truy cập của các dịch vụ. Chúng ta sẽ cấu hình bảo mật đa tầng, chỉ mở những cổng kết nối cần thiết nhất.

1. **Security Group cho Load Balancer (```ticket-app-alb-sg```)**:
   * Chọn **Security Groups** ở menu trái -> Click **Create security group**.
   * **Security group name**: ```ticket-app-alb-sg```.
   * **Description**: ```Security group for Application Load Balancer```.
   * **VPC**: Chọn VPC ```ticket-app-vpc```.
   * **Inbound rules** -> Click **Add rule**:
     * **Rule 1**: Type: ```HTTP``` | Source: ```Anywhere-IPv4``` (```0.0.0.0/0```).
     * **Rule 2**: Type: ```HTTPS``` | Source: ```Anywhere-IPv4``` (```0.0.0.0/0```).
   * Click **Create security group**.

![ALB SG](/images/5-Workshop/5.3-Network-Security/sg_alb_create.png)

2. **Security Group cho EC2 Instance (```ticket-app-ec2-worker-sg```)**:
   * Click **Create security group**.
   * **Security group name**: ```ticket-app-ec2-worker-sg```.
   * **Description**: ```Security group for EC2 instances```.
   * **VPC**: Chọn VPC ```ticket-app-vpc```.
   * **Inbound rules** -> Click **Add rule**:
     * Type: ```HTTP``` | Port range: ```80``` | Source: Chọn **Custom** -> Bấm vào ô tìm kiếm và chọn Security Group ```ticket-app-alb-sg``` vừa tạo ở bước trên (Điều này đảm bảo EC2 chỉ nhận traffic đi qua Load Balancer).
   * Click **Create security group**.

![EC2 SG](/images/5-Workshop/5.3-Network-Security/sg_ec2_create.png)

3. **Security Group cho Redis Cache (```ticket-app-redis-sg```)**:
   * Click **Create security group**.
   * **Security group name**: ```ticket-app-redis-sg```.
   * **Description**: ```Security group for ElastiCache Redis```.
   * **VPC**: Chọn VPC ```ticket-app-vpc```.
   * **Inbound rules** -> Click **Add rule**:
     * Type: ```Custom TCP``` | Port range: ```6379``` | Source: Chọn **Custom** -> chọn Security Group ```ticket-app-ec2-worker-sg``` (Đảm bảo chỉ các máy chủ chạy Web/Worker backend mới được phép truy cập Cache).
   * Click **Create security group**.

![Redis SG](/images/5-Workshop/5.3-Network-Security/sg_redis_create.png)

4. **Security Group cho RDS Proxy (```ticket-app-rds-proxy-sg```)**:
   * Click **Create security group**.
   * **Security group name**: ```ticket-app-rds-proxy-sg```.
   * **Description**: ```Security group for RDS Proxy```.
   * **VPC**: Chọn VPC ```ticket-app-vpc```.
   * **Inbound rules** -> Click **Add rule**:
     * Type: ```PostgreSQL``` (port `5432`) | Source: Chọn **Custom** -> chọn Security Group ```ticket-app-ec2-worker-sg``` (Chỉ nhận kết nối database từ các máy chủ chạy backend).
   * Click **Create security group**.

![RDS Proxy SG](/images/5-Workshop/5.3-Network-Security/sg_proxy_create.png)

5. **Security Group cho RDS Instance (```ticket-app-rds-instance-sg```)**:
   * Click **Create security group**.
   * **Security group name**: ```ticket-app-rds-instance-sg```.
   * **Description**: ```Security group for RDS instance```.
   * **VPC**: Chọn VPC ```ticket-app-vpc```.
   * **Inbound rules** -> Click **Add rule**:
     * Type: ```PostgreSQL``` (port `5432`) | Source: Chọn **Custom** -> chọn Security Group ```ticket-app-rds-proxy-sg``` (Bảo mật tối đa: Chặn kết nối trực tiếp từ EC2 đến database. Database chỉ chấp nhận kết nối đi qua RDS Proxy).
   * Click **Create security group**.

![RDS Instance SG](/images/5-Workshop/5.3-Network-Security/sg_rds_create.png)

![Security Groups Complete](/images/5-Workshop/5.3-Network-Security/security_groups.png)
