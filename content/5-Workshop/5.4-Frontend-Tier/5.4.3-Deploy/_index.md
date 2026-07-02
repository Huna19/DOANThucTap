---
title : "Deploy Frontend"
date : 2024-01-01
weight : 3
chapter : false
pre : " <b> 5.4.3. </b> "
---

### Deploy Frontend to S3

In this final section, we will configure the connection parameters, build the Frontend React source code into static files, and then upload everything to the S3 Frontend Bucket to launch the website.

---

#### 1. Configure and Build Frontend Source Code

Before uploading the Frontend code to S3, we need to configure the Frontend to communicate with the Cognito User Pool and API Gateway.

1. Navigate to the Frontend source code directory on your computer (the ```ticket-booking-frontend``` directory).
2. Create or edit the environment configuration file ```.env``` in the Frontend directory:
   ```env
   NEXT_PUBLIC_API_URL=https://ticket-app-api-url (API Gateway URL - see Chapter 5.7)
   NEXT_PUBLIC_COGNITO_USER_POOL_ID=us-east-1_xxxxx (See Chapter 5.7)
   NEXT_PUBLIC_COGNITO_CLIENT_ID=xxxxxxxxxxxx (See Chapter 5.7)
   NEXT_PUBLIC_COGNITO_REGION=us-east-1
   ```
3. Open a Terminal in the Frontend directory and run the following commands to install dependencies and build the project:
   ```bash
   npm install
   npm run build
   ```
   * After running successfully, an ```out``` folder will be created containing static files (index.html, JS, CSS, images).

---

#### 2. Upload Source Code to S3 Frontend Bucket

1. Go back to the S3 Bucket details page for ```frontend-ticket-app-app-<your-account-id>``` on the AWS Console.
2. In the **Objects** tab, click **Upload**.

   ![S3 Upload Button](/images/5-Workshop/5.4-Frontend-Tier/s3_upload_btn.jpg)

3. Drag and drop all files and subfolders **inside** the ```out``` folder generated in the previous step into the upload area.
   * *Note: The `index.html` file must be uploaded directly to the root directory of the S3 Bucket.*

   ![S3 Upload Files](/images/5-Workshop/5.4-Frontend-Tier/s3_upload_files.jpg)

4. Click **Upload** at the bottom of the page and wait for the process to complete.

   ![S3 Execute Upload](/images/5-Workshop/5.4-Frontend-Tier/s3_upload_execute.jpg)

After a successful upload, access the website through the CloudFront Distribution domain name to confirm the interface is displaying correctly.
