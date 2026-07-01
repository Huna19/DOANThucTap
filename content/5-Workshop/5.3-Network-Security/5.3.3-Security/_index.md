---
title : "Security & Security Groups"
date : 2024-01-01
weight : 3
chapter : false
pre : " <b> 5.3.3. </b> "
---

### Security & Security Groups

In this section, we will configure credentials storage using AWS Secrets Manager and set up Security Groups for resources.

---

#### 1. Create AWS Secrets Manager to store DB Credentials

{{% notice info %}}
We use AWS Secrets Manager to manage Database credentials. The Backend servers will retrieve credentials automatically, avoiding hardcoding passwords.
{{% /notice %}}

1. Open the [AWS Secrets Manager console](https://us-east-1.console.aws.amazon.com/secretsmanager/home?region=us-east-1#/listSecrets).
2. Click **Store a new secret**.

![Store Secret Button](/images/5-Workshop/5.3-Network-Security/secret_store_btn.png)
3. Select secret type: **Credentials for Amazon RDS database** or **Other type of secret**:
   * Input Key/Value:
     * Key: ```username``` | Value: ```postgres```
     * Key: ```password``` | Value: Enter your database password (e.g. ```TicketingAppPassword2026!```).

![Secrets Type and Credentials](/images/5-Workshop/5.3-Network-Security/secret_type_credentials.png)

4. Click **Next**.
5. Configure Secret:
   * **Secret name**: Enter ```ticket-app/rds/credentials```.

![Secrets Name](/images/5-Workshop/5.3-Network-Security/secret_name.png)

6. Click **Next** -> Keep rotation settings as default -> click **Store**.

![Secrets Manager Complete](/images/5-Workshop/5.3-Network-Security/secrets_complete.png)

---

#### 2. Initialize and Configure Security Groups

Security Groups act as virtual firewalls. We configure a multi-layered model to allow only necessary connections.

1. **Security Group for Load Balancer (```ticket-app-alb-sg```)**:
   * Select **Security Groups** on the left menu -> Click **Create security group**.

![Create Security Group Button](/images/5-Workshop/5.3-Network-Security/sg_create_btn.png)
   * **Security group name**: ```ticket-app-alb-sg```.
   * **Description**: ```Security group for Application Load Balancer```.
   * **VPC**: Select the ```ticket-app-vpc``` VPC.
   * **Inbound rules** -> Click **Add rule**:
     * **Rule 1**: Type: ```HTTP``` | Source: ```Anywhere-IPv4``` (```0.0.0.0/0```).
     * **Rule 2**: Type: ```HTTPS``` | Source: ```Anywhere-IPv4``` (```0.0.0.0/0```).
   * Click **Create security group**.

![ALB SG](/images/5-Workshop/5.3-Network-Security/sg_alb.png)

2. **Security Group for EC2 Instance (```ticket-app-ec2-worker-sg```)**:
   * Click **Create security group**.
   * **Security group name**: ```ticket-app-ec2-worker-sg```.
   * **Description**: ```Security group for EC2 instances```.
   * **VPC**: Select the ```ticket-app-vpc``` VPC.
   * **Inbound rules** -> Click **Add rule**:
     * Type: ```HTTP``` | Port range: ```80``` | Source: Select **Custom** -> Search and choose ```ticket-app-alb-sg``` (Ensures EC2 only accepts traffic from the Load Balancer).
   * Click **Create security group**.

![EC2 SG](/images/5-Workshop/5.3-Network-Security/sg_ec2_worker.png)

3. **Security Group for Redis Cache (```ticket-app-redis-sg```)**:
   * Click **Create security group**.
   * **Security group name**: ```ticket-app-redis-sg```.
   * **Description**: ```Security group for ElastiCache Redis```.
   * **VPC**: Select the ```ticket-app-vpc``` VPC.
   * **Inbound rules** -> Click **Add rule**:
     * Type: ```Custom TCP``` | Port range: ```6379``` | Source: Select **Custom** -> choose ```ticket-app-ec2-worker-sg```.
   * Click **Create security group**.

![Redis SG](/images/5-Workshop/5.3-Network-Security/sg_redis.png)

4. **Security Group for RDS Proxy (```ticket-app-rds-proxy-sg```)**:
   * Click **Create security group**.
   * **Security group name**: ```ticket-app-rds-proxy-sg```.
   * **Description**: ```Security group for RDS Proxy```.
   * **VPC**: Select the ```ticket-app-vpc``` VPC.
   * **Inbound rules** -> Click **Add rule**:
     * Type: ```PostgreSQL``` (port `5432`) | Source: Select **Custom** -> choose ```ticket-app-ec2-worker-sg```.
   * Click **Create security group**.

![RDS Proxy SG](/images/5-Workshop/5.3-Network-Security/sg_rds_proxy.png)

5. **Security Group for RDS Instance (```ticket-app-rds-instance-sg```)**:
   * Click **Create security group**.
   * **Security group name**: ```ticket-app-rds-instance-sg```.
   * **Description**: ```Security group for RDS instance```.
   * **VPC**: Select the ```ticket-app-vpc``` VPC.
   * **Inbound rules** -> Click **Add rule**:
     * Type: ```PostgreSQL``` (port `5432`) | Source: Select **Custom** -> choose ```ticket-app-rds-proxy-sg``` (Ensures DB only accepts connections from the RDS Proxy).
   * Click **Create security group**.

![RDS Instance SG](/images/5-Workshop/5.3-Network-Security/sg_rds_instance.png)
