---
title : "RDS PostgreSQL & RDS Proxy"
date : 2024-01-01
weight : 1
chapter : false
pre : " <b> 5.6.1. </b> "
---

### Database RDS PostgreSQL & RDS Proxy

In this section, we will configure the **Amazon RDS PostgreSQL** (Multi-AZ) database and integrate **RDS Proxy** to optimize concurrent database connections.

---

#### 1. Initialize Amazon RDS PostgreSQL Multi-AZ

For security, the database instance only accepts internal connections from Private Subnets and is deployed with Multi-AZ for failover redundancy.

1. Open the [Amazon RDS console](https://us-east-1.console.aws.amazon.com/rds/home?region=us-east-1#).
2. Create DB Subnet Group:
   * Select **Subnet groups** -> click **Create DB subnet group**.

   ![RDS Subnet Group Button](/images/5-Workshop/5.6-Database-Caching/rds_subnet_group_btn.png)

   * **Name**: ```db-subnet-group-ticket-app```.

   ![RDS Subnet Group Name](/images/5-Workshop/5.6-Database-Caching/rds_subnet_group_name.png)

   * **VPC**: Select the ```ticket-app-vpc``` VPC.
   * **Availability Zones**: Select ```us-east-1a``` and ```us-east-1b```.
   * **Subnets**: Select the two **Private Subnets** (CIDR `10.0.11.0/24` and `10.0.12.0/24`).

   ![RDS Subnet Group Subnets](/images/5-Workshop/5.6-Database-Caching/rds_subnet_group_subnets.png)

   * Click **Create**.

   ![RDS Subnet Group Create Button](/images/5-Workshop/5.6-Database-Caching/rds_subnet_group_create_btn.jpg)

3. Go back to **Databases** -> click **Create database**:

   ![RDS Create Database Button](/images/5-Workshop/5.6-Database-Caching/rds_create_btn.png)

   * **Engine options**: Select **PostgreSQL**.
   * **Templates**: Select **Production** or **Dev/Test**.
   * **Deployment options**: Select **Multi-AZ DB instance**.
   * **Settings**:
     * **DB instance identifier**: ```database-ticket-app```.
     * **Master username**: ```postgres```.
     * **Master password**: Enter matching password with Secrets Manager.
   * **Connectivity**:
     * **Virtual private cloud (VPC)**: Select your VPC.
     * **DB subnet group**: Select ```db-subnet-group-ticket-app```.
     * **Public access**: Select **No**.

   ![RDS Connectivity](/images/5-Workshop/5.6-Database-Caching/rds_connectivity.png)

     * **VPC security group**: Select DB Security Group (e.g. `ticket-app-rds-instance-sg`).

   ![RDS Security Group](/images/5-Workshop/5.6-Database-Caching/rds_security_group.png)

   * Click **Create database** at the bottom of the page.

   ![RDS Create Database Button](/images/5-Workshop/5.6-Database-Caching/rds_create_btn_bottom.jpg)

---

#### 2. Configure Amazon RDS Proxy

1. Select **Proxies** -> click **Create proxy**.

   ![RDS Proxy Create Button](/images/5-Workshop/5.6-Database-Caching/rds_proxy_create_btn.jpg)

2. In the **Create proxy** configuration:
   * **Proxy identifier**: ```rds-proxy-ticket-app```.
   * **Engine family**: Select **PostgreSQL**.
   * **Target group configuration**:
     * **Database**: Select the ```database-ticket-app```.
   * **Authentication**:
     * **Secrets Manager secret**: Select ```ticket-app/rds/credentials```.
     * **IAM role**: Select **Create an IAM role**.

   ![RDS Proxy Authentication](/images/5-Workshop/5.6-Database-Caching/rds_proxy_auth.jpg)

   * **Connectivity**:
     * **Subnets**: Select Private Subnets.
     * **VPC security group**: Select Proxy Security Group (e.g. `ticket-app-rds-proxy-sg`).
3. Click **Create proxy**.
