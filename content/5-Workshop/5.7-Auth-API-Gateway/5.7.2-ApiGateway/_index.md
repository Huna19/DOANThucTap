---
title : "API Gateway & Authorizer"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.7.2. </b> "
---

### API Gateway & JWT Authorizer

We use **AWS API Gateway** (HTTP API) to secure API endpoints via a **Cognito JWT Authorizer**.

---

#### 1. Create HTTP API

1. Open the [Amazon API Gateway console](https://us-east-1.console.aws.amazon.com/apigateway/main/apis?region=us-east-1).

2. Click **Create API**.

![API Gateway Create API](/images/5-Workshop/5.7-Auth-API-Gateway/api_create_btn.png)

3. Under **HTTP API**, click **Build**.

4. Click **Add integration**:
   * Integration type: Select **HTTP endpoint**.
   * Enter the raw URL of the Beanstalk Application Load Balancer, e.g. `http://ticket-app-backend-ALB-123456789.us-east-1.elb.amazonaws.com` (Do absolutely NOT append `/` or `{proxy}`).

5. Under **API name**: Enter ```ticket-app-api```.

6. Click **Review and create** -> Click **Create**.

7. Once the API is created, copy the **Invoke URL** displayed on the screen to configure your Frontend `NEXT_PUBLIC_API_URL`.

![Create HTTP API](/images/5-Workshop/5.7-Auth-API-Gateway/api_integration.png)

---

#### 2. Create Cognito JWT Authorizer

1. On the left menu, select **Authorization** -> switch to the **Manage authorizers** tab -> click **Create**.

2. Select Authorizer type as **JWT**.

3. Fill in the following information:
   * **Name**: ```ticket-app-cognito-authorizer```.
   * **Identity source**: Enter ```$request.header.Authorization```.
   * **Issuer URL**: Enter the Cognito URL in this format: `https://cognito-idp.<AWS::Region>.amazonaws.com/<UserPoolId>` (replace with your actual Region and User Pool ID).
   * **Audience**: Enter the **App Client ID**.

4. Click **Create**.

![Create JWT Authorizer](/images/5-Workshop/5.7-Auth-API-Gateway/jwt_authorizer.png)

---

#### 3. Create Routes and Attach Authorizer

> **💡 Note:** Exact routes are always prioritized over the greedy `{proxy+}` parameter. The `{proxy+}` variable requires a trailing path, so it will not match the root `/api` or `/`.

1. On the left menu, select **Routes** -> click **Create route**.

2. Declare the **Public Routes** (No login required) one by one:
   * Declare Method and Path (e.g., `POST` and `/api/auth/login`) -> click **Create**.

![API Gateway Create Route](/images/5-Workshop/5.7-Auth-API-Gateway/api_routes.png)

   * Open the newly created Route and ensure the Integration is attached to the HTTP endpoint (ALB). (If not, select Attach integration).
   * Switch to the **Authorization** section and ensure it is set to **NONE**.
   * Create the same for the following public routes:
     * ```POST /api/auth/register```
     * ```POST /api/auth/refresh```
     * ```GET /health```
     * ```POST /api/payments/momo/ipn```
     * ```GET /api/matches```
     * ```GET /api/matches/{matchId}```

3. Create the **Protected Route** (Login required):
   * Declare Method as **ANY** and Path as `/api/{proxy+}` -> click **Create**.
   * Ensure the Route is attached to the HTTP endpoint (ALB).
   * Switch to the **Authorization** section -> Select **ticket-app-cognito-authorizer**.

---

#### 4. Configure CORS

AWS recommends configuring CORS at the HTTP API level instead of manually handling OPTIONS requests in the backend.

1. On the left menu, select **CORS**.

2. Configure the following fields:
   * **Allowed Origins**: Enter your CloudFront domain (e.g. `https://dxxxxxxxxxx.cloudfront.net`). Click Add.
   * **Allowed Headers**: Enter `authorization`, `content-type`. Click Add.
   * **Allowed Methods**: Select `GET`, `POST`, `PUT`, `DELETE`, `OPTIONS`.
   * **Credentials**: Select **Yes** (You must declare a specific Allowed Origins above).
   * **Max age**: `300`.

![API Gateway CORS](/images/5-Workshop/5.7-Auth-API-Gateway/api_cors.png)

3. Click **Save**.
