---
title : "Resource Cleanup"
date : 2024-01-01
weight : 9
chapter : false
pre : " <b> 5.9. </b> "
---

### Resource Cleanup

{{% notice warning %}}
To avoid incurring unexpected costs on your personal AWS account, please clean up all resources immediately after completing the hands-on lab.
{{% /notice %}}

Please choose the appropriate cleanup method based on the deployment method you used in Chapter **5.2**:

*   **Case A: If you deployed using CloudFormation (Option A in Chapter 5.2)**
    *   Do **NOT** manually delete individual resources first. Doing so will break the CloudFormation Stack's state, leading to errors where the Stack gets stuck or reports `DELETE_FAILED` during deletion.
    *   Scroll down and follow **Section 2. CloudFormation Cleanup Instructions**.
*   **Case B: If you manually created resources (Option B in Chapter 5.2)**
    *   Follow **Section 1. Clean Up Manually Deployed Resources**.

---

#### 1. Clean Up Manually Deployed Resources (For Option B)

Delete resources in the following order from top to bottom:

1. **Delete Elastic Beanstalk Environments**:
   * Open the [Elastic Beanstalk console](https://us-east-1.console.aws.amazon.com/elasticbeanstalk/home?region=us-east-1#/environments).
   * Select the environment ```ticket-app-Backend-env``` -> click **Actions** -> select **Terminate environment**.
   * Repeat the same to Terminate the ```ticket-app-Worker-env``` environment.
   * Wait until the environment termination is complete, then delete the Application: Go to the **Applications** page -> select ```ticket-app-App``` -> click **Actions** -> **Delete application**.

2. **Delete API Gateway**:
   * Open the [API Gateway console](https://us-east-1.console.aws.amazon.com/apigateway/main/apis?region=us-east-1).
   * Select your HTTP API (e.g., `TicketAppAPI`) -> click **Delete** -> Confirm deletion.

3. **Delete CloudFront Distribution**:
   * Open the [CloudFront console](https://us-east-1.console.aws.amazon.com/cloudfront/v3/home?region=us-east-1#/distributions).
   * Select your Distribution -> click **Disable**. This process will take a few minutes.
   * Once the status changes to Disabled, select the Distribution again -> click **Delete**.

4. **Delete RDS Proxy & RDS PostgreSQL**:
   * Open the [Amazon RDS console](https://us-east-1.console.aws.amazon.com/rds/home?region=us-east-1#databases:).
   * Select **Proxies** -> Select ```rds-proxy-ticket-app``` -> click **Actions** -> **Delete**.
   * Select **Databases** -> Select the Database instance ```database-ticket-app``` -> click **Actions** -> **Delete**:
     * Select **No** for creating a final snapshot (to delete quickly without backup).
     * Check the confirmation box and enter ```delete me``` to confirm deletion.

5. **Delete ElastiCache Redis Replication Group**:
   * Open the [ElastiCache console](https://us-east-1.console.aws.amazon.com/elasticache/home?region=us-east-1#/clusters).
   * Select the Redis cluster ```ticket-app-redis``` -> click **Actions** -> **Delete**.

6. **Delete Cognito User Pool**:
   * Open the [Amazon Cognito console](https://us-east-1.console.aws.amazon.com/cognito/v2/home?region=us-east-1#).
   * Select User Pool ```ticket-app-user-pool``` -> click **Delete user pool**.

7. **Delete AWS CodePipeline, CodeBuild & CodeCommit**:
   * Open the **CodePipeline console**:
     * Select pipelines ```ticket-app-backend-pipeline``` and ```ticket-app-worker-pipeline``` -> click **Delete**.
   * Open the **CodeBuild console**:
     * Select projects ```ticket-app-backend-build``` and ```ticket-app-worker-build``` -> click **Delete**.
   * Open the **CodeCommit console**:
     * Select repositories ```ticket-app-backend``` and ```ticket-app-worker``` -> click **Delete**.

8. **Delete Amazon SQS, SNS & CloudWatch Alarm**:
   * Open the **CloudWatch console** -> **Alarms**: Select Alarm `ticket-app-checkout-dlq-alarm` -> click **Delete**.
   * Open the **Amazon SQS console**: Select `booking-queue.fifo` and `checkout-dlq.fifo` -> click **Delete**.
   * Open the **Amazon SNS console**: Select the Topics (`booking-notification-topic` and `booking-notification-topic-for-user`) -> click **Delete**.

9. **Delete SES Identity & SMTP Credentials**:
   * Open the **Amazon SES console**: Select **Identities** -> Select your Email -> click **Delete**.
   * Open the **IAM console**: Select **Users** -> Select User `ticket-app-smtp-user` -> click **Delete**.

10. **Delete Secrets Manager**:
    * Open the [Secrets Manager console](https://us-east-1.console.aws.amazon.com/secretsmanager/home?region=us-east-1#!/listSecrets).
    * Select your secret (containing the DB password) -> click **Actions** -> **Delete secret**. (Enter a waiting period of 7 days).

11. **Delete S3 Buckets**:
    * Open the [Amazon S3 console](https://s3.console.aws.amazon.com/s3/home?region=us-east-1#).
    * You must **Empty** (delete all files) the bucket before you can delete it:
      * Select the Frontend Bucket ```frontend-ticket-app-app-<your-account-id>``` -> click **Empty** -> enter `permanently delete` to confirm.
      * Perform the same for the Assets Bucket ```ticket-app-assets-<your-account-id>```.
      * After emptying, select the Buckets -> click **Delete** -> enter the bucket name to confirm permanent deletion.

12. **Delete Network Infrastructure (VPC, NAT, IGW, SGs)**:
    * Open the [VPC console](https://us-east-1.console.aws.amazon.com/vpc/home?region=us-east-1).
    * **NAT Gateways**: Delete the 2 NAT Gateways. (This process will take a few minutes).
    * **Elastic IPs**: Release the 2 EIPs associated with the NATs.
    * **VPC**: Select VPC `ticket-app-vpc` -> click **Actions** -> **Delete VPC**. This action will automatically delete the associated Subnets, Route Tables, Internet Gateway, and Security Groups (as long as there are no dependent resources). Ensure all resources above (EC2, RDS, ElastiCache, Beanstalk, ELB) are completely deleted before performing this step.

---

#### 2. CloudFormation Cleanup Instructions (For Option A)

If you deployed the core infrastructure using the CloudFormation template file in Chapter 5.2:

1. Open the [AWS CloudFormation console](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks).
2. Select your Stack (e.g., `ticket-app-stack`).
3. Click **Delete** on the toolbar at the top.
4. Confirm **Delete stack**.

5. The system will automatically release all network and server resources (VPC, Subnets, NAT Gateways, Beanstalk, RDS, Redis, S3, Cognito...) safely and cleanly without requiring manual cleanup steps.
