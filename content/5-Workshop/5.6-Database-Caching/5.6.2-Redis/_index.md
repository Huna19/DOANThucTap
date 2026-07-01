---
title : "Configure ElastiCache Redis"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.6.2. </b> "
---

### Configure Amazon ElastiCache Redis

In this section, we will create a temporary cache cluster using **Amazon ElastiCache Redis**.

---

#### Step-by-Step Instructions:

1. Open the [Amazon ElastiCache console](https://us-east-1.console.aws.amazon.com/elasticache/home?region=us-east-1#/clusters).
2. Create Subnet Group for Redis:
   * Select **Subnet groups** -> click **Create cache subnet group**.

   ![Redis Subnet Group Button](/images/5-Workshop/5.6-Database-Caching/redis_subnet_group_btn.png)

   * **Name**: ```ticket-app-redis-subnet-group``` -> Select VPC ```ticket-app-vpc```.

   ![Redis Subnet Group Name](/images/5-Workshop/5.6-Database-Caching/redis_subnet_group_name.png)

   * **Subnets**: Select two **Private Subnets** (`ticket-app-subnet-private-a` and `ticket-app-subnet-private-b`).

   ![Redis Subnet Group Subnets](/images/5-Workshop/5.6-Database-Caching/redis_subnet_group_subnets.png)

   * Click **Create**.

3. Go back to **Redis OSS caches** -> click **Create Redis OSS cache**:
   * **Engine**: Select **Redis OSS**.
   * **Deployment option**: Select **Node-based cluster**.
   * **Creation method**: Select **Cluster cache**.

   ![Redis Cluster Options](/images/5-Workshop/5.6-Database-Caching/redis_cluster_options.png)

   * **Cluster mode**: Select **Disabled** (Simple Primary/Replica mechanism).
   * **Name**: ```ticket-app-redis```.

   ![Redis Cluster Name](/images/5-Workshop/5.6-Database-Caching/redis_cluster_name.png)

   * **Node type**: Select ```cache.t3.micro```.
   * **Number of replicas**: Enter ```1```.

   ![Redis Node Type](/images/5-Workshop/5.6-Database-Caching/redis_node_type.png)

   * **Subnet group**: Select ```ticket-app-redis-subnet-group```.

   ![Redis Connectivity](/images/5-Workshop/5.6-Database-Caching/redis_connectivity.png)

   * **Security**: Select Redis Security Group (e.g. `ticket-app-redis-sg`).

   ![Redis Security Group](/images/5-Workshop/5.6-Database-Caching/redis_security_group.png)

4. Click **Create** to initialize.
