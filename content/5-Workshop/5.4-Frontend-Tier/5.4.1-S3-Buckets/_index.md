---
title : "Create Amazon S3 Buckets"
date : 2024-01-01
weight : 1
chapter : false
pre : " <b> 5.4.1. </b> "
---

### Create Amazon S3 Buckets

In this section, we will create 2 S3 Buckets for the project: one Bucket as static hosting for the Frontend website, and another Bucket to store static resources (Assets) such as match images and e-tickets uploaded by the Backend.

---

#### 1. Create Amazon S3 Bucket for Frontend

The S3 Bucket will block all public access entirely. Only the CloudFront Distribution will have read access to this Bucket.

1. Open the [Amazon S3 console](https://s3.console.aws.amazon.com/s3/home?region=us-east-1#).
2. Click **Create bucket**.

   ![S3 Create](/images/5-Workshop/5.4-Frontend-Tier/s3_create.png)
3. In the **Create bucket** configuration interface:
   * **Bucket name**: Enter a globally unique name following this format: ```frontend-ticket-app-app-<your-account-id>``` (e.g., `frontend-ticket-app-app-123456789012`).
   * **AWS Region**: Select ```us-east-1``` (or the region you are using for the lab).
   * **Object Ownership**: Select **ACLs disabled (recommended)**.
   * **Block Public Access settings for this bucket**:
     * Check **Block all public access** (Completely block direct access from the internet).

![S3 Bucket Name](/images/5-Workshop/5.4-Frontend-Tier/s3_create_name.png)
![S3 Object Ownership](/images/5-Workshop/5.4-Frontend-Tier/s3_create_ownership.png)
![S3 Create Button](/images/5-Workshop/5.4-Frontend-Tier/s3_create_button.png)

   * Keep the other default settings and click **Create bucket** at the bottom of the page.

---

#### 2. Create Amazon S3 Bucket for Assets (Images & E-tickets)

{{% notice info %}}
In addition to the Frontend Bucket, the application needs a separate S3 Bucket to store match images, e-tickets, and other assets uploaded by the Backend. This bucket allows public access to display images on the frontend interface.
{{% /notice %}}

1. Return to the [Amazon S3 console](https://s3.console.aws.amazon.com/s3/home?region=us-east-1#) → click **Create bucket**.
2. In the **Create bucket** configuration interface:
   * **Bucket name**: Enter a name following this format: ```ticket-app-assets-<your-account-id>``` (e.g., `ticket-app-assets-123456789012`).
   * **AWS Region**: Select ```us-east-1``` (or the region you are using for the lab).

   ![S3 Assets Bucket Name](/images/5-Workshop/5.4-Frontend-Tier/s3_assets_create_name.jpg)

   * **Object Ownership**: Select **ACLs disabled (recommended)**.

   ![S3 Assets Ownership](/images/5-Workshop/5.4-Frontend-Tier/s3_assets_create_ownership.jpg)

   * **Block Public Access settings for this bucket**:
     * **Uncheck** the **Block all public access** box (Allow public read access for images).
     * Check the acknowledgment box "I acknowledge that the current settings might result in this bucket and the objects within becoming public."

   ![S3 Assets Public Access](/images/5-Workshop/5.4-Frontend-Tier/s3_assets_public_access.jpg)

3. Click **Create bucket** at the bottom of the page.
4. After the bucket is created, go to the bucket details page → select the **Permissions** tab → scroll to **Cross-origin resource sharing (CORS)** → click **Edit** → paste the following CORS configuration:
   ```json
   [
     {
       "AllowedHeaders": ["*"],
       "AllowedMethods": ["GET", "PUT", "POST"],
       "AllowedOrigins": ["*"],
       "MaxAgeSeconds": 3000
     }
   ]
   ```
5. Click **Save changes**.
