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

   ![EB IAM Trusted Entity](/images/5-Workshop/5.5-Application-Messaging/eb_iam_trusted_entity.png)

4. Find and check the following **Managed Policies**:
   * `AWSElasticBeanstalkWebTier`
   * `AWSElasticBeanstalkWorkerTier`
   * `AWSElasticBeanstalkMulticontainerDocker`
5. Click **Next** -> Enter **Role name**: `ticket-app-beanstalk-ec2-role`.
6. Click **Create role**.

   ![IAM Create Role](/images/5-Workshop/5.5-Application-Messaging/iam_create_role_btn.png)

7. Open the newly created `ticket-app-beanstalk-ec2-role`, select the **Permissions** tab -> click **Add permissions** -> **Create inline policy**.

   ![EB IAM Add Inline Policy](/images/5-Workshop/5.5-Application-Messaging/eb_iam_add_inline_policy.png)
8. Instead of manually searching and adding each service, you can copy the standard JSON Policy below (extracted from the project's Infrastructure as Code template) and paste it into the **JSON** tab:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sqs:SendMessage",
                "sqs:ReceiveMessage",
                "sqs:DeleteMessage",
                "sqs:GetQueueAttributes",
                "sqs:GetQueueUrl",
                "sqs:ChangeMessageVisibility"
            ],
            "Resource": "arn:aws:sqs:*:*:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ses:SendEmail",
                "ses:SendRawEmail"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "sns:Publish"
            ],
            "Resource": "arn:aws:sns:*:*:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue"
            ],
            "Resource": "arn:aws:secretsmanager:*:*:secret:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::*",
                "arn:aws:s3:::*/*"
            ]
        }
    ]
}
```

9. Click **Next** -> Save the Inline Policy as `ticket-app-beanstalk-inline-policy` and click **Create policy**.

---

#### 2. Deploy Beanstalk Backend (Web Server Environment)

**Step 1.1: Create Application**
1. Open the [AWS Elastic Beanstalk console](https://us-east-1.console.aws.amazon.com/elasticbeanstalk/home?region=us-east-1#/applications).
2. Click **Create application** (on the Applications page).
3. Enter **Application name**: ```ticket-app-App``` and click **Create**.

**Step 1.2: Create Environment (Backend)**
1. In the `ticket-app-App` Application management screen, click **Create a new environment** (or **Create environment**).
2. At **Step 1 - Configure environment**:
   * **Environment tier**: Select **Web server environment**.
   * **Application name**: Ensure it is `ticket-app-App`.
   * **Environment name**: Enter `ticket-app-Backend-env`.
   * **Platform**: Select **Node.js**.
   * **Platform branch**: Select **Node.js 20 running on 64bit Amazon Linux 2023**.
   * **Platform version**: Select **6.11.3 (Recommended)**.
   * **Application code**: Select **Sample application**.
   * Click **Next**.

![EB Create Environment](/images/5-Workshop/5.5-Application-Messaging/eb_create_env.png)
![EB Platform](/images/5-Workshop/5.5-Application-Messaging/eb_platform.png)

7. Configure **Step 2 - Configure service access**:
   * **Service role**: Select **aws-elasticbeanstalk-service-role**.
   * **EC2 instance profile**: Select `ticket-app-beanstalk-ec2-role` (Created in Step 1).
   * **EC2 key pair**: Select `test` (Or your own key pair).
   * Click **Next**.

![EB Service Access](/images/5-Workshop/5.5-Application-Messaging/eb_service_access.jpg)
8. Configure **Step 3 - Set up networking**:
   * **VPC**: Select the project VPC (e.g., `ticket-app-vpc`).
   * **Public IP address**: Select **Disabled**.
   * **Instance subnets**: Check two **Private Subnets** (e.g., `ticket-app-subnet-private-a` and `ticket-app-subnet-private-b`).
   * Click **Next**.

![EB Instance Subnets](/images/5-Workshop/5.5-Application-Messaging/eb_instance_subnets.jpg)

9. Configure **Step 4 - Configure instance traffic and scaling**:
   * **EC2 security groups**: Check the `ticket-app-ec2-worker-sg` Security Group.
   * Scroll down to **Capacity** -> **Auto scaling group**:
     * **Environment type**: Select **Load balanced**.
     * **Min instances**: Enter `2`.
     * **Max instances**: Enter `4`.

![EB Security and Scaling](/images/5-Workshop/5.5-Application-Messaging/eb_security_scaling.jpg)

10. Still in Step 4, scroll down to **Load balancer network settings**:
   * **Visibility**: Select **Public**.
   * **Load balancer subnets**: Check two **Public Subnets** (e.g., `ticket-app-subnet-public-a` and `ticket-app-subnet-public-b`).

![EB Load Balancer Subnets](/images/5-Workshop/5.5-Application-Messaging/eb_lb_subnets.jpg)

11. Under the **Processes** section (below Load balancer security groups), check the default process (usually `default`), click **Actions -> Edit**:
   * Change **Health check path** from `/` to `/health`. Click **Save**.
   * Skip the remaining configurations by clicking **Next** until the final screen (Step 6 - Review), click **Submit** to initialize the environment.

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
   * Under the **CloudWatch Logs** section, check **Stream logs** and set **Retention** to `7 days`.
   * Under **Environment properties**, add:
     * ```PORT```: ```8080```
     * ```AWS_REGION```: ```us-east-1```
     * ```DB_HOST```: *(Enter RDS Proxy endpoint)*
     * ```DB_PORT```: ```5432```
     * ```DB_NAME```: ```ticketing_db```
     * ```DB_USER```: ```postgres```
     * ```DB_PASSWORD```: ```TicketingAppPassword2026!```
     * ```DATABASE_URL```: ```postgresql://postgres:TicketingAppPassword2026!@<rds-proxy-endpoint>:5432/ticketing_db``` *(Replace `<rds-proxy-endpoint>` with your actual RDS Proxy endpoint)*
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
