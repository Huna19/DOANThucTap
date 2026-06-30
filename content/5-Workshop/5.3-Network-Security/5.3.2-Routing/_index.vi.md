---
title : "Định tuyến & NAT Gateways"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.3.2. </b> "
---

### Định tuyến & NAT Gateways (Routing & NAT Gateways)

Trong phần này, chúng ta sẽ cấu hình các cổng Internet Gateway, NAT Gateways và bảng định tuyến (Route Tables) để định hướng luồng mạng cho các Subnets.

---

#### 1. Cấu hình Internet Gateway & NAT Gateways

Để các máy chủ trong Private Subnets có thể kết nối ra internet tải thư viện mà vẫn đảm bảo tính riêng tư, ta cần cấu hình NAT Gateway.

1. **Tạo Internet Gateway (IGW)**:
   * Trên thanh điều hướng, chọn **Internet gateways** -> click **Create internet gateway**.

   ![Create IGW Button](/images/5-Workshop/5.3-Network-Security/igw_create_btn.png)
   ![Create IGW](/images/5-Workshop/5.3-Network-Security/igw_name.png)

   * **Name tag**: Nhập ```ticket-app-igw``` -> click **Create internet gateway**.
   * Sau khi tạo xong, click **Actions** -> Chọn **Attach to VPC**.

   ![Attach IGW Button](/images/5-Workshop/5.3-Network-Security/igw_attach_btn.png)

   * Chọn VPC ```ticket-app-vpc``` -> click **Attach internet gateway**.

   ![Attach IGW](/images/5-Workshop/5.3-Network-Security/igw_attach_vpc.png)

2. **Cấp phát Elastic IPs**:
   * Chọn **Elastic IPs** -> click **Allocate Elastic IP address**.

   ![Allocate EIP Button](/images/5-Workshop/5.3-Network-Security/eip_allocate_btn.png)
   ![Allocate EIP](/images/5-Workshop/5.3-Network-Security/eip_allocate_confirm.png)

   * Click **Allocate** (Lặp lại bước này 2 lần để có 2 địa chỉ IP tĩnh cho 2 NAT Gateways).

3. **Khởi tạo NAT Gateways**:
   * Chọn **NAT gateways** -> click **Create NAT gateway**:

   ![Create NAT Button](/images/5-Workshop/5.3-Network-Security/nat_create_btn.png)

     * **Name**: ```ticket-app-nat-gateway-a```
     * **Subnet**: Chọn ```ticket-app-subnet-public-a``` (Bắt buộc phải nằm ở Public Subnet).
     * **Elastic IP allocation ID**: Chọn địa chỉ EIP thứ nhất vừa cấp phát.
     * Click **Create NAT gateway**.

     ![NAT Gateway A Details](/images/5-Workshop/5.3-Network-Security/nat_a_details.png)
     ![NAT Gateway A EIP](/images/5-Workshop/5.3-Network-Security/nat_a_eip.png)

   * Click **Create NAT gateway** một lần nữa để tạo cái thứ hai:
     * **Name**: ```ticket-app-nat-gateway-b```
     * **Subnet**: Chọn ```ticket-app-subnet-public-b```.
     * **Elastic IP allocation ID**: Chọn địa chỉ EIP thứ hai.
     * Click **Create NAT gateway**.

     ![NAT Gateway B Details](/images/5-Workshop/5.3-Network-Security/nat_b_details.png)
     ![NAT Gateway B EIP](/images/5-Workshop/5.3-Network-Security/nat_b_eip.png)

---

#### 2. Cấu hình Route Tables (Bảng định tuyến)

Chúng ta cần phân tách luồng định tuyến cho Public Subnets (đi qua Internet Gateway) và Private Subnets (đi qua NAT Gateways).

1. **Bảng định tuyến Public (Public Route Table)**:
   * Chọn **Route tables** -> click **Create route table**.

   ![Create Route Table Button](/images/5-Workshop/5.3-Network-Security/rt_create_btn.png)
   ![Create Public Route Table](/images/5-Workshop/5.3-Network-Security/rt_public_name.png)

   * **Name**: ```ticket-app-public-rt``` -> Chọn VPC ```ticket-app-vpc``` -> click **Create**.
   * Chọn route table ```ticket-app-public-rt``` vừa tạo -> Chọn tab **Routes** -> click **Edit routes**:

   ![Edit Public Routes Button](/images/5-Workshop/5.3-Network-Security/rt_public_edit_routes_btn.png)

     * Click **Add route**: Destination ```0.0.0.0/0``` -> Target chọn **Internet Gateway** -> Chọn ```ticket-app-igw```.
     * Click **Save changes**.

     ![Edit Public Routes](/images/5-Workshop/5.3-Network-Security/rt_public_add_route_igw.png)

   * Chuyển sang tab **Subnet associations** -> click **Edit subnet associations**:

   ![Edit Public Subnets Button](/images/5-Workshop/5.3-Network-Security/rt_public_edit_subnet_assoc_btn.png)

     * Tích chọn **ticket-app-subnet-public-a** và **ticket-app-subnet-public-b** -> click **Save associations**.

     ![Edit Public Subnets](/images/5-Workshop/5.3-Network-Security/rt_public_assoc_subnets.png)

2. **Bảng định tuyến Private A (Private Route Table A)**:
   * Click **Create route table** -> Name: ```ticket-app-private-rt-a``` -> Chọn VPC -> click **Create**.
   * Tab **Routes** -> click **Edit routes** -> Add route: Destination ```0.0.0.0/0``` -> Target chọn **NAT Gateway** -> Chọn ```ticket-app-nat-gateway-a``` -> Save.

   ![Edit Private A Routes Button](/images/5-Workshop/5.3-Network-Security/rt_private_a_edit_routes_btn.png)
   ![Edit Private A Routes](/images/5-Workshop/5.3-Network-Security/rt_private_a_add_route_nat.png)

   * Tab **Subnet associations** -> Edit -> Chọn **ticket-app-subnet-private-a** -> Save.

   ![Edit Private A Subnets Button](/images/5-Workshop/5.3-Network-Security/rt_private_a_edit_subnet_assoc_btn.png)
   ![Edit Private A Subnets](/images/5-Workshop/5.3-Network-Security/rt_private_a_assoc_subnets.png)

3. **Bảng định tuyến Private B (Private Route Table B)**:
   * Thực hiện tương tự, tạo route table ```ticket-app-private-rt-b``` -> trỏ ```0.0.0.0/0``` đến **NAT Gateway B** -> Associate với **ticket-app-subnet-private-b**.

   ![Private B Route Table](/images/5-Workshop/5.3-Network-Security/rt_private_b_view.png)
