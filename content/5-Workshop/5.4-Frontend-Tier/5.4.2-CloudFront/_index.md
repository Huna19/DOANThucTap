---
title : "Configure CloudFront & OAC"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.4.2. </b> "
---

### Configure CloudFront Distribution & Security OAC

After creating the S3 Buckets, we will configure an **Amazon CloudFront Distribution** as an edge CDN to distribute static content. At the same time, we configure **Origin Access Control (OAC)** to ensure security by blocking direct public access to S3 from the internet.

---

#### 1. Create CloudFront Distribution & Configure OAC

1. Open the [Amazon CloudFront console](https://us-east-1.console.aws.amazon.com/cloudfront/v4/home?region=us-east-1#/distributions).
2. Click **Create distribution**.
3. In the **Create distribution** configuration interface:
   * **Distribution options**:
     * **Distribution name**: Enter ```ticket-app-frontend``` or leave it as default.
     * **Project type**: Select **Single website or app**.

   ![CloudFront Distribution Options](/images/5-Workshop/5.4-Frontend-Tier/cf_oac.png)

   * **Domain**:
     * Select **Skip domain setup** (We will use the default domain name issued by CloudFront).

   ![CloudFront Domain Setup](/images/5-Workshop/5.4-Frontend-Tier/cf_waf.png)

   * **Origin**:
     * **Origin type**: Select **Amazon S3**.
     * **S3 origin**: Click **Browse S3** -> Select the ```frontend-ticket-app-app-<your-account-id>``` bucket created in the previous step.

   ![CloudFront S3 Origin](/images/5-Workshop/5.4-Frontend-Tier/cf_price_class.png)

     * **Origin settings**: Select **Use recommended origin settings** (CloudFront will automatically create an OAC configuration to securely connect to the S3 Private Bucket).

{{% notice warning %}}
Note: The S3 Bucket must be a regular bucket (REST endpoint), and Static Website Hosting **must not be enabled** because OAC does not support Website Endpoints.
{{% /notice %}}

   ![CloudFront Origin Settings](/images/5-Workshop/5.4-Frontend-Tier/cf_origin_settings.jpg)

   * **Security protections**:
     * **AWS WAF**: Keep the default configuration and click **Next**.

   ![CloudFront Security Settings](/images/5-Workshop/5.4-Frontend-Tier/cf_waf_settings.jpg)

   {{% notice note %}}
   Note: Since **Project type = Single website or app** has been selected, AWS will automatically apply the appropriate default configuration for the CloudFront Distribution. For this workshop, just keep the default values and click **Next** to continue. Settings such as Cache Behavior, Viewer Protocol Policy, or Allowed HTTP Methods can be edited later if needed.
   {{% /notice %}}

4. Click **Create distribution** at the bottom.

   ![CloudFront Review and Create](/images/5-Workshop/5.4-Frontend-Tier/cf_review_2.jpg)

5. Once the Distribution is successfully created, CloudFront will display its details. Copy the **Distribution domain name** (e.g., `dxxxxxxxxxx.cloudfront.net`). This is the address used to access the website after deployment is complete.

6. Configure the **Default root object** for the Distribution:
   * Since the CloudFront creation wizard does not support setting the Default root object directly, you need to go to the details page of the newly created Distribution.
   * Under the **General** tab, scroll down to the **Settings** section -> click **Edit** on the right side.

   ![CloudFront Domain](/images/5-Workshop/5.4-Frontend-Tier/cf_domain.png)

   * In the **Default root object** field, enter ```index.html```.
   * Scroll to the bottom of the page and click **Save changes**.

   ![CloudFront Save Settings](/images/5-Workshop/5.4-Frontend-Tier/cf_save_settings.jpg)

---

#### 2. Configure Custom Error Responses for SPA

Since the Frontend application is built with React (a Single Page Application), we need to redirect 403/404 errors to `index.html` so React can handle the routing.

1. In the CloudFront Distribution management page you just created, switch to the **Error pages** tab.
2. Click **Create custom error response**.
3. Configure for **403** error:
   * **HTTP error code**: Select **403: Forbidden**.
   * **Customize error response**: Select **Yes**.
   * **Response page path**: Enter `/index.html`.
   * **HTTP Response code**: Enter **200: OK**.
   * Click **Create custom error response**.

   ![CloudFront Custom Error 403](/images/5-Workshop/5.4-Frontend-Tier/cf_error_403.png)

4. Repeat the steps above to configure for **404** error:
   * **HTTP error code**: Select **404: Not Found**.
   * **Customize error response**: Select **Yes**.
   * **Response page path**: Enter `/index.html`.
   * **HTTP Response code**: Enter **200: OK**.
   * Click **Create custom error response**.

   ![CloudFront Custom Error 404](/images/5-Workshop/5.4-Frontend-Tier/cf_error_404.png)

---

#### 3. Update S3 Bucket Policy

{{% notice note %}}
After the CloudFront Distribution is created, you must update the S3 Bucket Policy to allow the CloudFront Principal service to read files from your bucket.
{{% /notice %}}

1. In the newly created CloudFront Distribution details page, switch to the **Origins** tab.
2. Select the S3 origin and click **Edit**.

   ![CloudFront Origins Tab](/images/5-Workshop/5.4-Frontend-Tier/cf_origins_tab.jpg)

3. In the **Edit origin** interface, scroll down to the policy warning section and click **Copy policy**.

   ![CloudFront Copy Policy](/images/5-Workshop/5.4-Frontend-Tier/cf_copy_policy.jpg)

4. Go back to the S3 Bucket details page for ```frontend-ticket-app-app-<your-account-id>```:
   * Select the **Permissions** tab.
   * Scroll down to the **Bucket policy** section -> click **Edit**.

   ![S3 Edit Policy](/images/5-Workshop/5.4-Frontend-Tier/s3_edit_policy.jpg)

5. Paste the entire JSON policy content you just copied into the editor.

   ![S3 Paste Policy](/images/5-Workshop/5.4-Frontend-Tier/s3_paste_policy.jpg)

6. Scroll to the bottom and click **Save changes**.

   ![S3 Save Policy](/images/5-Workshop/5.4-Frontend-Tier/s3_save_policy_btn.jpg)
