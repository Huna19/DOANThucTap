---
title : "Khởi tạo VPC & Subnets"
date : 2024-01-01
weight : 1
chapter : false
pre : " <b> 5.3.1. </b> "
---

### Khởi tạo Amazon VPC & Subnets

Trong phần này, chúng ta sẽ tiến hành cấu hình dải mạng ảo **Amazon VPC** và chia thành **4 Subnets** (2 Public và 2 Private) nằm trên 2 Availability Zones khác nhau nhằm tăng tính dự phòng.

---

#### Các bước thực hiện:

1. Mở [Amazon VPC console](https://us-east-1.console.aws.amazon.com/vpc/home?region=us-east-1#Home:).
2. Trên thanh điều hướng bên trái, chọn **Your VPCs**, click **Create VPC**:

![Create VPC](/images/5-Workshop/5.3-Network-Security/vpc_create_btn.png)

3. Trong giao diện cấu hình **Create VPC**:
   * Chọn **VPC only**.
   * **Name tag**: Nhập ```ticket-app-vpc```.
   * **IPv4 CIDR block**: Nhập ```10.0.0.0/16```.
   * Giữ nguyên các cấu hình mặc định khác và click **Create VPC**.

![VPC Config Details](/images/5-Workshop/5.3-Network-Security/vpc_create_details.png)
![VPC Config Tags and Create](/images/5-Workshop/5.3-Network-Security/vpc_create_tags_btn.png)

4. Trên thanh điều hướng bên trái, chọn **Subnets**, click **Create subnet**:

![Create Subnet Button](/images/5-Workshop/5.3-Network-Security/subnet_create_btn.png)

   * **VPC ID**: Chọn VPC ```ticket-app-vpc``` vừa khởi tạo.
   * Tiến hành thêm lần lượt **4 Subnets** bằng cách click **Add new subnet**:

     ![Subnet VPC Name](/images/5-Workshop/5.3-Network-Security/subnet_create_vpc_name.png)
     ![Subnet AZ and CIDR](/images/5-Workshop/5.3-Network-Security/subnet_create_az_cidr.png)
     
     * **Subnet 1 (Public Subnet A)**:
       * **Subnet name**: ```ticket-app-subnet-public-a```
       * **Availability Zone**: Chọn Zone ```us-east-1a```.
       * **IPv4 CIDR block**: ```10.0.1.0/24```.
     
     * **Subnet 2 (Public Subnet B)**:
       * **Subnet name**: ```ticket-app-subnet-public-b```
       * **Availability Zone**: Chọn Zone ```us-east-1b```.
       * **IPv4 CIDR block**: ```10.0.2.0/24```.
     
     * **Subnet 3 (Private Subnet A)**:
       * **Subnet name**: ```ticket-app-subnet-private-a```
       * **Availability Zone**: Chọn Zone ```us-east-1a```.
       * **IPv4 CIDR block**: ```10.0.11.0/24```.
     
     * **Subnet 4 (Private Subnet B)**:
       * **Subnet name**: ```ticket-app-subnet-private-b```
       * **Availability Zone**: Chọn Zone ```us-east-1b```.
       * **IPv4 CIDR block**: ```10.0.12.0/24```.

5. Click **Create subnet** để hoàn tất khởi tạo.

![Subnets Created](/images/5-Workshop/5.3-Network-Security/subnets_created_list.png)
