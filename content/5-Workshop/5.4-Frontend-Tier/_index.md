---
title : "Frontend Tier"
date : 2024-01-01
weight : 4
chapter : false
pre : " <b> 5.4. </b> "
---

### Frontend Tier

In this section, we will configure static website hosting for the **Ticketing App** on **Amazon S3** and set up secure global content delivery via **Amazon CloudFront** using **Origin Access Control (OAC)** security mechanism.

#### Implementation Steps:

1. **[Create Amazon S3 Buckets](5.4.1-s3-buckets/)**
   * Create an S3 Bucket for static Frontend hosting.
   * Create an S3 Bucket for Assets to store match images and e-tickets, and configure CORS.

2. **[Configure CloudFront & OAC](5.4.2-cloudfront/)**
   * Create a CloudFront Distribution utilizing OAC to connect to S3.
   * Configure the Default Root Object and Custom Error Responses for SPA.
   * Update the S3 Bucket Policy to allow CloudFront access.

3. **[Deploy Frontend](5.4.3-deploy/)**
   * Configure environment variables (.env) and build the React static source code.
   * Upload the static files to the S3 Frontend Bucket to launch the website.
