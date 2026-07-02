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
git clone https://github.com/first-cloud-ai-journey/ticket-app-workshop.git
cd ticket-app-workshop
```



---

#### 4. Choose Infrastructure Deployment Method (VPC, RDS, Beanstalk, SQS,...)

In this workshop, you can choose one of the following two methods to build your network and server infrastructure:

*   **Option A (Recommended - Fast): Automate deployment using AWS CloudFormation**
    *   The infrastructure will be automatically initialized.
    *   Chapters **5.3 to 5.7** will serve as guides for you to **Verify and Validate** the created resources rather than recreating them.
*   **Option B: Manually configure step-by-step (Manual)**
    *   You will **skip** Step 4 (running CloudFormation) below.
    *   Starting from Chapter **5.3**, you will manually follow the instructions on the AWS Console to build the system from scratch.

---

#### Instructions for Option A: Automatic Deployment using CloudFormation

To prepare the environment for the workshop, we deploy the following CloudFormation template (click link): [TicketAppStack](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?stackName=ticket-app-stack&templateURL=https://fcaj-ticketing-templates.s3.amazonaws.com/template-cloudformation.yaml). Leave all default options.

{{% notice info %}}
**Note on Deployment Scope**: 
If you choose automatic deployment via CloudFormation, the system will automatically initialize the basic resources. You can **skip the manual creation steps** and only read the instructions to **Verify/Check** configurations for the following parts:
*   **Chapter 5.3 (Network & Security)**: Completely (VPC, Subnets, NAT, Security Groups).
*   **Chapter 5.4 (Frontend Tier)**: S3 Bucket creation step (you **still need to manually configure** CloudFront CDN + WAF).
*   **Chapter 5.5 (Application & Messaging Tier)**: Completely (Elastic Beanstalk Backend/Worker and SQS).
*   **Chapter 5.6 (Database & Caching)**: Secrets Manager configuration step (you **still need to manually create** RDS Database, RDS Proxy, and ElastiCache Redis).
*   **Chapter 5.7 (Auth & API Gateway)**: Cognito User Pool creation step (you **still need to manually create** API Gateway).
{{% /notice %}}

1. The browser will open the CloudFormation Console with the configuration pre-filled.
2. On the **Specify stack details** screen, verify the parameters and click **Next**.
3. Scroll to the bottom of the Review page, check **I acknowledge that AWS CloudFormation might create IAM resources with custom names.** and click **Submit** to start deployment.
4. Wait for the deployment process to complete (Status changes to `CREATE_COMPLETE`).

After the CloudFormation Stack deploys successfully, your basic infrastructure is complete! In the following chapters, if you choose **Option A**, you only need to navigate through the services to **verify and check** configurations, then proceed to the source code deployment steps.
