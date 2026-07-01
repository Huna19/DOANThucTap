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

   ![Redis Subnet Group Button](/images/5-Workshop/5.6-Database-Caching/redis_subnet_group_btn.png)

   * **Name**: ```ticket-app-redis-subnet-group``` -> Chọn VPC ```ticket-app-vpc```.

   ![Redis Subnet Group Name](/images/5-Workshop/5.6-Database-Caching/redis_subnet_group_name.png)

   * **Subnets**: Tích chọn hai **Private Subnets** (`ticket-app-subnet-private-a` và `ticket-app-subnet-private-b`).

   ![Redis Subnet Group Subnets](/images/5-Workshop/5.6-Database-Caching/redis_subnet_group_subnets.png)

   * Click **Create**.

3. Quay lại **Redis OSS caches** -> click **Create Redis OSS cache**:
   * **Engine**: Chọn **Redis OSS**.
   * **Deployment option**: Chọn **Node-based cluster**.
   * **Creation method**: Chọn **Cluster cache**.

   ![Redis Cluster Options](/images/5-Workshop/5.6-Database-Caching/redis_cluster_options.png)

   * **Cluster mode**: Chọn **Disabled** (Chúng ta sẽ dùng cơ chế Primary/Replica đơn giản).
   * **Name**: ```ticket-app-redis```.

   ![Redis Cluster Name](/images/5-Workshop/5.6-Database-Caching/redis_cluster_name.png)

   * **Node type**: Chọn node nhỏ như ```cache.t3.micro```.
   * **Number of replicas**: Nhập ```1```.

   ![Redis Node Type](/images/5-Workshop/5.6-Database-Caching/redis_node_type.png)

   * **Subnet group**: Chọn ```ticket-app-redis-subnet-group``` vừa tạo ở Bước 2.

   ![Redis Connectivity](/images/5-Workshop/5.6-Database-Caching/redis_connectivity.png)

   * **Security**: Chọn Security Group dành cho Redis (tên chứa `ticket-app-redis-sg`).

   ![Redis Security Group](/images/5-Workshop/5.6-Database-Caching/redis_security_group.png)

4. Click **Create** để hoàn thành khởi tạo.
