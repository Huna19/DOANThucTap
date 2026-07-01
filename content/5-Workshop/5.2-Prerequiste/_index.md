---
title : "Prerequisites"
date : 2024-01-01 
weight : 2
chapter : false
pre : " <b> 5.2. </b> "
---

### Prerequisites

To successfully complete this hands-on workshop to build the **Ticket-App** online event ticketing platform, you need to prepare your local development environment and configure the appropriate AWS account permissions.

---

#### 1. IAM Permissions

You need to use an IAM User or IAM Role with appropriate permissions to clean up and operate the resources in this workshop.

{{% notice note %}}
For the most convenient personal lab practice and to avoid permission errors (Access Denied), we recommend using **AdministratorAccess** permissions for your lab account.
{{% /notice %}}

If you want to configure a least privilege policy, follow these steps to create an IAM Policy on the AWS Console:

1. Sign in to the **AWS Management Console** and navigate to the **IAM** service.
2. Select **Policies** on the left navigation bar, then click **Create policy**.
3. In the policy creation interface, switch to the **JSON** editor, clear any default template code, and paste the following JSON policy block:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ElasticBeanstalkCleanup",
      "Effect": "Allow",
      "Action": [
        "elasticbeanstalk:TerminateEnvironment",
        "elasticbeanstalk:DeleteApplication",
        "elasticbeanstalk:DeleteApplicationVersion",
        "elasticbeanstalk:DeleteConfigurationTemplate"
      ],
      "Resource": "*"
    },
    {
      "Sid": "EC2AndAutoScalingCleanup",
      "Effect": "Allow",
      "Action": [
        "ec2:TerminateInstances",
        "ec2:DeleteSecurityGroup",
        "ec2:DeleteSubnet",
        "ec2:DeleteVpc",
        "ec2:DeleteInternetGateway",
        "ec2:DetachInternetGateway",
        "ec2:DeleteNatGateway",
        "ec2:DeleteRouteTable",
        "ec2:DeleteRoute",
        "ec2:DisassociateRouteTable",
        "ec2:ReleaseAddress",
        "ec2:DeleteVpcEndpoints",
        "ec2:DescribeInstances",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs",
        "ec2:DescribeSubnets",
        "ec2:DescribeInternetGateways",
        "ec2:DescribeNatGateways",
        "ec2:DescribeRouteTables",
        "ec2:DescribeAddresses",
        "ec2:DescribeVpcEndpoints",
        "ec2:DescribeNetworkInterfaces",
        "autoscaling:DeleteAutoScalingGroup",
        "autoscaling:UpdateAutoScalingGroup",
        "autoscaling:DeleteLaunchConfiguration",
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeLaunchConfigurations"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "aws:RequestedRegion": "us-east-1"
        }
      }
    },
    {
      "Sid": "RDSCleanup",
      "Effect": "Allow",
      "Action": [
        "rds:DeleteDBInstance",
        "rds:DeleteDBProxy",
        "rds:DeregisterDBProxyTargets",
        "rds:DeleteDBSubnetGroup",
        "rds:DescribeDBInstances",
        "rds:DescribeDBProxies",
        "rds:DescribeDBSubnetGroups"
      ],
      "Resource": "*"
    },
    {
      "Sid": "ElastiCacheCleanup",
      "Effect": "Allow",
      "Action": [
        "elasticache:DeleteReplicationGroup",
        "elasticache:DeleteCacheSubnetGroup",
        "elasticache:DescribeReplicationGroups",
        "elasticache:DescribeCacheSubnetGroups"
      ],
      "Resource": "*"
    },
    {
      "Sid": "SQSCleanup",
      "Effect": "Allow",
      "Action": [
        "sqs:DeleteQueue",
        "sqs:GetQueueUrl",
        "sqs:ListQueues"
      ],
      "Resource": "*"
    },
    {
      "Sid": "SNSCleanup",
      "Effect": "Allow",
      "Action": [
        "sns:DeleteTopic",
        "sns:ListTopics"
      ],
      "Resource": "*"
    },
    {
      "Sid": "CognitoCleanup",
      "Effect": "Allow",
      "Action": [
        "cognito-idp:DeleteUserPool",
        "cognito-idp:DescribeUserPool"
      ],
      "Resource": "*"
    },
    {
      "Sid": "S3Cleanup",
      "Effect": "Allow",
      "Action": [
        "s3:DeleteBucket",
        "s3:DeleteObject",
        "s3:DeleteObjectVersion",
        "s3:ListBucket",
        "s3:ListBucketVersions",
        "s3:GetBucketLocation"
      ],
      "Resource": "*"
    },
    {
      "Sid": "APIGatewayCleanup",
      "Effect": "Allow",
      "Action": [
        "apigateway:DELETE",
        "apigateway:GET"
      ],
      "Resource": "*"
    },
    {
      "Sid": "CloudFrontCleanup",
      "Effect": "Allow",
      "Action": [
        "cloudfront:DeleteDistribution",
        "cloudfront:GetDistribution",
        "cloudfront:UpdateDistribution"
      ],
      "Resource": "*"
    },
    {
      "Sid": "CodePipelineCleanup",
      "Effect": "Allow",
      "Action": [
        "codepipeline:DeletePipeline",
        "codepipeline:GetPipeline"
      ],
      "Resource": "*"
    },
    {
      "Sid": "CodeBuildCleanup",
      "Effect": "Allow",
      "Action": [
        "codebuild:DeleteProject",
        "codebuild:BatchGetProjects"
      ],
      "Resource": "*"
    },
    {
      "Sid": "CodeCommitCleanup",
      "Effect": "Allow",
      "Action": [
        "codecommit:DeleteRepository",
        "codecommit:GetRepository"
      ],
      "Resource": "*"
    },
    {
      "Sid": "SecretsManagerCleanup",
      "Effect": "Allow",
      "Action": [
        "secretsmanager:DeleteSecret",
        "secretsmanager:ListSecrets"
      ],
      "Resource": "*"
    },
    {
      "Sid": "CloudWatchCleanup",
      "Effect": "Allow",
      "Action": [
        "cloudwatch:DeleteAlarms",
        "cloudwatch:DescribeAlarms",
        "logs:DeleteLogGroup",
        "logs:DescribeLogGroups"
      ],
      "Resource": "*"
    },
    {
      "Sid": "IAMCleanup",
      "Effect": "Allow",
      "Action": [
        "iam:DeleteRole",
        "iam:DeleteRolePolicy",
        "iam:DeleteInstanceProfile",
        "iam:RemoveRoleFromInstanceProfile",
        "iam:DetachRolePolicy",
        "iam:ListRolePolicies",
        "iam:ListAttachedRolePolicies",
        "iam:GetRole",
        "iam:GetInstanceProfile"
      ],
      "Resource": "*"
    },
    {
      "Sid": "ELBCleanup",
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:DeleteLoadBalancer",
        "elasticloadbalancing:DeleteTargetGroup",
        "elasticloadbalancing:DescribeLoadBalancers",
        "elasticloadbalancing:DescribeTargetGroups"
      ],
      "Resource": "*"
    },
    {
      "Sid": "KMSDescribe",
      "Effect": "Allow",
      "Action": [
        "kms:DescribeKey",
        "kms:ListKeys"
      ],
      "Resource": "arn:aws:kms:us-east-1:<your-account-id>:key/*"
    }
  ]
}
```

5. Click **Next**.
6. Enter a name for the policy (e.g., `TicketAppCleanupPolicy`), add an optional description, and click **Create policy**.
7. Attach this policy to your **IAM User** (navigate to **Users** -> select your User -> **Add permissions** -> **Attach policies directly** and select the `TicketAppCleanupPolicy` you just created).

![Create IAM Policy](/images/5-Workshop/5.2-Prerequiste/iam_policy.png)

---

#### 2. Local Workspace Setup

Ensure your workstation has the following tools installed and configured:

##### A. Node.js & npm
*   The Ticket-App application is written in Node.js. You need Node.js version **18.x** or **20.x** (LTS).
*   Verify your installation:
    ```bash
    node -v
    npm -v
    ```

##### B. Git
*   Used to fetch the project source code.
*   Verify your installation:
    ```bash
    git --version
    ```

##### C. AWS CLI & Configure
*   Install the AWS Command Line Interface (AWS CLI) to interact with your AWS account.
*   After installation, run the following command to configure your credentials (Access Key & Secret Key) of the authorized IAM User:
    ```bash
    aws configure
    ```
    *   *Default region name:* `us-east-1` (N. Virginia)
    *   *Default output format:* `json`

---

#### 3. Download Project Source Code

The Ticket-App source code is structured into three main directories:
1.  **ticket-booking-frontend/**: Static React UI showing event list and handling ticket purchases.
2.  **ticket-booking-backend/** (Backend API): Node.js API (Express) validating requests, authenticating users via Cognito, and publishing events to SQS.
3.  **ticket-booking-worker/** (Worker): Background processor consuming messages from SQS FIFO and writing transactions to the PostgreSQL DB.

Clone the project from your workshop repository:
```bash
git clone https://github.com/free-cloud-journey/ticket-app-workshop.git
cd ticket-app-workshop
```

![Download Source Code](/images/5-Workshop/5.2-Prerequiste/git_clone.png)

---

#### 4. Choose Infrastructure Deployment Method (VPC, RDS, Beanstalk, SQS,...)

In this workshop, you can choose one of the following two methods to build your network and server infrastructure:

*   **Option A (Recommended - Fast): Automate deployment using AWS CloudFormation**
    *   The infrastructure will be automatically initialized in about 15-20 minutes.
    *   Chapters **5.3 to 5.7** will serve as guides for you to **Verify and Validate** the created resources rather than recreating them.
*   **Option B: Manually configure step-by-step (Manual)**
    *   You will **skip** Step 4 (running CloudFormation) below.
    *   Starting from Chapter **5.3**, you will manually follow the instructions on the AWS Console to build the system from scratch.

---

#### Instructions for Option A: Automatic Deployment using CloudFormation

The entire core infrastructure of the application (VPC, RDS, Redis, Beanstalk, SQS, Cognito, API Gateway, CloudFront, CI/CD Pipeline) will be deployed automatically using the CloudFormation template file ```template.yaml```.

1. Open the [AWS CloudFormation console](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks).
2. Click **Create stack** -> select **With new resources (standard)**.
3. In the **Prerequisite - Prepare template** interface, select **Template is ready**:
   * **Template source**: Select **Upload a template file**.
   * Click **Choose file** and upload the ```template.yaml``` file from your project directory.
   * Click **Next**.

4. In the **Specify stack details** interface:
   * **Stack name**: Enter ```ticket-app-stack```.
   * **Parameters**:
     * **EnvironmentName**: Enter ```ticket-app```.
     * **DBMasterUsername**: ```postgres```.
     * **DBName**: ```ticketing_db``` (Be sure to use this Database name consistently throughout the lab).
     * Keep the other default parameters.
   * Click **Next**.

5. In the **Configure stack options** interface, keep the default configuration and click **Next**.
6. In the **Review ticket-app-stack** interface:
   * Scroll to the bottom of the page, check **I acknowledge that AWS CloudFormation might create IAM resources with custom names.** (Confirm granting CloudFormation permission to create IAM Roles).
   * Click **Submit** to start deployment.

7. The deployment process will take approximately **15 - 20 minutes** to initialize all resources (especially RDS Multi-AZ, CloudFront CDN, and Beanstalk Environments). Wait until the status changes to **CREATE_COMPLETE**.

After the CloudFormation Stack deploys successfully, your basic infrastructure is complete! In the following chapters, if you choose **Option A**, you only need to navigate through the services to **verify and check** configurations, then proceed to the source code deployment steps.