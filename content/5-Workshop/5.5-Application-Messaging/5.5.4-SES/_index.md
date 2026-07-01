---
title : "Configure Email (SES)"
date : 2024-01-01
weight : 4
chapter : false
pre : " <b> 5.5.4. </b> "
---

### Configure Amazon Simple Email Service (SES)

Our Ticket Booking system has a feature to automatically send notification emails to customers when a booking is successful (via a background Worker). To achieve this, you need to configure **Amazon SES** to verify the sender email address and retrieve the SMTP credentials.

---

#### 1. Verify Sender Email Address (Email Identity)

1. Open the [Amazon SES console](https://us-east-1.console.aws.amazon.com/ses/home?region=us-east-1).
2. On the left menu, select **Identities** (under Configuration).
3. Click the **Create identity** button.

   ![SES Create Identity Button](/images/5-Workshop/5.5-Application-Messaging/ses_create_identity_btn.jpg)

4. Configure Identity:
   * **Identity type**: Select **Email address**.
   * **Email address**: Enter your real email address (e.g., `your-email@gmail.com`). This will be the email address used to send messages (MAIL_FROM).

   ![SES Identity Type](/images/5-Workshop/5.5-Application-Messaging/ses_create_identity_type.jpg)

5. Click **Create identity**.

{{% notice warning %}}
**Important:** AWS SES will immediately send an email with the subject *Amazon Web Services – Email Address Verification Request* to your inbox. You **must** open that email and click the confirmation link. After verification, the Identity status in SES will change to **Verified**.
{{% /notice %}}

   ![SES Identity Verified](/images/5-Workshop/5.5-Application-Messaging/ses_identity_verified.jpg)

---

#### 2. Create SMTP Credentials (Mail Account)

For the application (Worker) to call the SES service and send emails, we need to grant it a pair of SMTP Username/Password.

1. Still in the [Amazon SES console](https://us-east-1.console.aws.amazon.com/ses/home?region=us-east-1), select **SMTP settings** on the left menu.
2. Click the **Create SMTP credentials** button in the center of the page.

   ![SES SMTP Settings](/images/5-Workshop/5.5-Application-Messaging/ses_smtp_settings.jpg)

3. This will open a new tab redirecting to the IAM interface:
   * **IAM User Name**: You can leave it as default or change it to `ticket-app-smtp-user`.

   ![SES SMTP Create User](/images/5-Workshop/5.5-Application-Messaging/ses_smtp_create_user.jpg)

   * Click **Create user**.
4. The next screen will display the **SMTP username** and **SMTP password**.
5. **CRITICALLY IMPORTANT:** Click **Download Credentials** (download the CSV file) or copy these 2 parameters carefully to Notepad. You will not be able to view this password again after closing the screen!
   * These two parameters are the `SMTP_USERNAME` and `SMTP_PASSWORD` that you need to enter in the **Environment properties** configuration of the Worker environment on Beanstalk (completed in Chapter 5.5.2).

   ![SES SMTP Download](/images/5-Workshop/5.5-Application-Messaging/ses_smtp_download.jpg)

{{% notice info %}}
In the default SES Sandbox environment, you can only send emails TO verified email addresses. Therefore, when testing the ticket booking feature, enter the email address you verified in Step 1 (or verify additional emails) to receive notifications!
{{% /notice %}}
