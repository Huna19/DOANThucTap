---
title : "Deploy Beanstalk Backend & Worker"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.5.2. </b> "
---

### Deploy Elastic Beanstalk Environments

In this section, we will deploy the API Backend server and the Worker server using **AWS Elastic Beanstalk**, and configure environment properties.

---

#### 1. Create IAM Role for EC2 Instance Profile

Elastic Beanstalk requires an IAM Role (Instance Profile) to grant EC2 instances permissions to communicate with other services (SQS, S3, RDS, SES).

1. Open the **IAM Console** -> select **Roles** -> click **Create role**.
2. Select **Trusted entity type**: **AWS service**.
3. Select **Use case**: **EC2** -> click **Next**.
4. Find and check the following **Managed Policies**:
   * `AWSElasticBeanstalkWebTier`
   * `AWSElasticBeanstalkWorkerTier`
   * `AWSElasticBeanstalkMulticontainerDocker`
5. Click **Next** -> Enter **Role name**: `ticket-app-beanstalk-ec2-role`.
6. Click **Create role**.

![EB IAM Role](/images/5-Workshop/5.5-Application-Messaging/eb_iam_role.png)
7. Open the newly created `ticket-app-beanstalk-ec2-role`, select the **Permissions** tab -> click **Add permissions** -> **Create inline policy**.
8. Add access permissions to SQS, SES, SNS, S3, and Secrets Manager. (You can grant FullAccess to these services if you are in a Lab environment to save time, or use a standard JSON Policy).
9. Save the Inline Policy as `ticket-app-beanstalk-inline-policy`.

---

#### 2. Deploy Beanstalk Backend (Web Server Environment)

**Step 1.1: Create Application**
1. Open the [AWS Elastic Beanstalk console](https://us-east-1.console.aws.amazon.com/elasticbeanstalk/home?region=us-east-1#/applications).
2. Click **Create application** (on the Applications page).
3. Enter **Application name**: ```ticket-app-App``` and click **Create**.

**Step 1.2: Create Environment (Backend)**
1. Inside the ```ticket-app-App``` application, click **Create a new environment**.
2. **Environment tier**: Select **Web server environment**.
3. **Environment name**: Enter ```ticket-app-Backend-env```.
4. **Platform**: Select **Node.js** and **Platform branch**: **Node.js 20 running on 64bit Amazon Linux 2023**.
5. **Application code**: Select **Sample application**.
6. Click **Next**.

![EB Create Environment](/images/5-Workshop/5.5-Application-Messaging/eb_create_env.png)
![EB Platform](/images/5-Workshop/5.5-Application-Messaging/eb_platform.png)

7. Configure **Service Access**:
   * **Service role**: Select **Use an existing service role** or let the system create a new one.
   * **EC2 instance profile**: Select the `ticket-app-beanstalk-ec2-role` created in Step 1.
   * Click **Next**.

![EB Service Access](/images/5-Workshop/5.5-Application-Messaging/eb_service_access.png)
8. Configure **Networking**:
   * **VPC**: Select the ```ticket-app-vpc``` VPC.
   * **Instance subnets**: Check the two **Private Subnets**.
   * **Load balancer subnets**: Check the two **Public Subnets**.
   * Click **Next**.
9. Configure **Instances**:
   * Under **EC2 security groups**, select the `ticket-app-ec2-worker-sg` (or the equivalent one created in the Network section) to allow EC2 instances to access RDS and Redis.
   * Click **Next**.

![EB Instances SG](/images/5-Workshop/5.5-Application-Messaging/eb_instances_sg.png)
10. Configure **Capacity** (Auto Scaling):
   * **Environment type**: Select **Load balanced**.
   * **Instances**: t3.micro.
   * **Auto Scaling Group**: Min: ```2```, Max: ```4```.
   * **Scaling triggers**: Metric: ```CPUUtilization``` (Upper: ```70%```, Lower: ```30%```).
   * Click **Next**.
11. Configure **Load balancer network and security** (Crucial Step):
   * Under **Load balancer security groups**, select `ticket-app-alb-sg`.
   * In the **Processes** table, select the default process (usually `default`), click **Actions -> Edit**.
   * Change the **Health check path** from `/` to `/health`. Click **Save**.
   * Skip remaining configurations by clicking **Next** until the review page, then click **Submit** to initialize.

![EB Application and Environment](/images/5-Workshop/5.5-Application-Messaging/beanstalk_environments.png)

---

#### 3. Deploy Beanstalk Worker (Web Server Environment)

{{% notice important %}}
Important Note: The Beanstalk Worker Environment in this project is actually a Node.js process actively polling messages via the AWS SDK. Thus, we deploy it as a **Web server environment** (Load balanced) similar to the Backend, rather than using Beanstalk's specialized Worker Environment.
{{% /notice %}}

1. Go back to the Elastic Beanstalk application ```ticket-app-App``` page.
2. Click **Create new environment** (top right).
3. **Environment tier**: Select **Web server environment**.
4. **Environment name**: Enter ```ticket-app-Worker-env```.
5. Platform should be Node.js 20.
6. Configure **Service Access** and **Networking** exactly like the Backend above.
7. Configure **Instances**, **Capacity**, and **Load balancer**:
   * **EC2 security groups**: Select `ticket-app-ec2-worker-sg`.
   * **Load balancer security groups**: Select `ticket-app-alb-sg`.
   * **Processes Health check path**: Change to `/health`.
8. Click **Submit** to initialize.

---

#### 4. Configure Environment Properties

Configure environment properties directly on the Beanstalk Console:

1. **Configure Backend (```ticket-app-Backend-env```)**:
   * Go to ```ticket-app-Backend-env``` details -> click **Configuration** -> **Updates, monitoring, and logging** -> click **Edit**.
   * Under **Environment properties**, add:
     * ```PORT```: ```8080```
     * ```AWS_REGION```: ```us-east-1```
     * ```DB_HOST```: *(Enter RDS Proxy endpoint)*
     * ```DB_PORT```: ```5432```
     * ```DB_NAME```: ```ticketing_db```
     * ```DB_USER```: ```postgres```
     * ```DB_PASSWORD```: ```TicketingAppPassword2026!```
     * ```REDIS_HOST```: *(Enter Redis Primary endpoint)*
     * ```REDIS_PORT```: ```6379```
     * ```SQS_BOOKING_QUEUE_URL```: ```https://sqs.us-east-1.amazonaws.com/<your-account-id>/booking-queue.fifo```
     * ```COGNITO_USER_POOL_ID```: *(See Chapter 5.7)*
     * ```COGNITO_CLIENT_ID```: *(See Chapter 5.7)*
     * ```CLOUDFRONT_DOMAIN```: ```https://<your-cloudfront-domain>.cloudfront.net```
     * ```MOMO_PARTNER_CODE```: ```MOMO```
     * ```MOMO_ACCESS_KEY```: ```F8BBA842ECF85```
     * ```MOMO_SECRET_KEY```: ```K951B6PE1waDMi640xX08PD3vg6EkVlz```
     * ```MOMO_ENDPOINT```: ```https://test-payment.momo.vn/v2/gateway/api```
     * ```S3_BUCKET_NAME```: ```ticket-app-assets-<your-account-id>```
     * ```S3_REGION```: ```us-east-1```
     * ```SNS_OPS_TOPIC_ARN```: *(ARN of OpsNotificationTopic)*
     * ```SNS_USER_TOPIC_ARN```: *(ARN of UserNotificationTopic)*
     * ```MOMO_IPN_URL```: ```https://<apigw-domain>/api/payments/momo/ipn```
     * ```MOMO_REDIRECT_URL```: ```https://<cloudfront-domain>/payment/result```
     * ```RESERVATION_TIMEOUT_MINUTES```: ```15```
   * Click **Apply**.

![Backend Environment Properties](/images/5-Workshop/5.5-Application-Messaging/backend_properties.png)

2. **Configure Worker (```ticket-app-Worker-env```)**:
   * Similar to the Backend, go to the **Environment properties** of the Worker and enter the variables:
     * *(Copy all connection variables for DB, Redis, SQS, S3, SNS just like the Backend).*
     * ```WORKER_CONCURRENCY```: ```5```
     * ```VISIBILITY_TIMEOUT_SECONDS```: ```60```
     * ```POLL_WAIT_TIME_SECONDS```: ```20```
     * ```SMTP_HOST```: ```email-smtp.us-east-1.amazonaws.com```
     * ```SMTP_PORT```: ```587```
     * ```SMTP_USERNAME```: *(SES SMTP Username)*
     * ```SMTP_PASSWORD```: *(SES SMTP Password)*
     * ```MAIL_FROM```: *(Verified SES Email)*
     * ```MAIL_FROM_NAME```: ```Ticket Booking```
   * Click **Apply**.

![Worker Environment Properties](/images/5-Workshop/5.5-Application-Messaging/worker_properties.png)
