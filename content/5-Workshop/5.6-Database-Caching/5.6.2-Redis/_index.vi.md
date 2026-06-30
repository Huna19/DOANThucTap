---
title : "Cấu hình ElastiCache Redis"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.6.2. </b> "
---

### Cấu hình Amazon ElastiCache Redis

Trong phần này, chúng ta sẽ tạo cache lưu trữ dữ liệu tạm thời bằng cụm bộ nhớ đệm **Amazon ElastiCache Redis**.

---

#### Các bước thực hiện:

1. Mở [Amazon ElastiCache console](https://us-east-1.console.aws.amazon.com/elasticache/home?region=us-east-1#/clusters).
2. Tạo nhóm Subnet cho Redis:
   * Trên thanh điều hướng, chọn **Subnet groups** -> click **Create cache subnet group**.
   * **Name**: ```ticket-app-redis-subnet-group``` -> Chọn VPC của bạn.

   ![Redis Subnet Group Name](/images/5-Workshop/5.6-Database-Caching/redis_subnet_group_name.png)

   * **Subnets**: Chọn hai **Private Subnets**.

   ![Redis Subnet Group Subnets](/images/5-Workshop/5.6-Database-Caching/redis_subnet_group_subnets.png)

   * Click **Create**.

   ![Redis Subnet Group Create Button](/images/5-Workshop/5.6-Database-Caching/redis_subnet_group_btn.png)

3. Quay lại **Redis clusters** -> click **Create Redis cluster**:
   * **Cluster mode**: Chọn **Disabled** (Chúng ta sẽ dùng cơ chế Primary/Replica đơn giản).

   ![Redis Cluster Options](/images/5-Workshop/5.6-Database-Caching/redis_cluster_options.png)

   * **Name** / **Replication group ID**: ```ticket-app-redis```.

   ![Redis Cluster Name](/images/5-Workshop/5.6-Database-Caching/redis_cluster_name.png)

   * **Node type**: Chọn node nhỏ như ```cache.t3.micro```.
   * **Number of replicas**: Nhập ```1```.

   ![Redis Node Type](/images/5-Workshop/5.6-Database-Caching/redis_node_type.png)

   * **Subnet group**: Chọn ```ticket-app-redis-subnet-group``` vừa tạo ở Bước 2.

   ![Redis Connectivity](/images/5-Workshop/5.6-Database-Caching/redis_connectivity.png)

   * **Security**: Chọn Security Group dành cho Redis (tên chứa `ticket-app-redis-sg`).

   ![Redis Security Group](/images/5-Workshop/5.6-Database-Caching/redis_security_group.png)

4. Click **Create** để hoàn thành khởi tạo.

   *(Ghi chú: Bạn nhớ chụp lại ảnh Redis Cluster created để chèn vào nhé, file ảnh hiện tại chưa có trong thư mục)*

5. Khi cụm Redis đã tạo xong, copy địa chỉ **Primary endpoint** của cụm để cấu hình.
