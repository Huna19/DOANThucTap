---
title : "Cognito User Pool"
date : 2024-01-01
weight : 1
chapter : false
pre : " <b> 5.7.1. </b> "
---

### Identity Management with Amazon Cognito

Cognito manages user registration, logins, and issues JWT Access Tokens for the Client.

---

#### Step-by-Step Instructions:

1. Open the [Amazon Cognito console](https://us-east-1.console.aws.amazon.com/cognito/v2/home?region=us-east-1#).

2. Select **User pools** -> Click **Create user pool** (New UI: **Set up resources for your application**).

![Cognito Create User Pool](/images/5-Workshop/5.7-Auth-API-Gateway/cognito_create_btn.png)

3. Under **1. Tell us about your application** -> **Define your application**:
   * **Application type**: Select **Single-page application (SPA)** *(For React SPA architecture, this defaults to no Client Secret)*.
   * **Name your application**: Enter ```ticket-app-user-pool```.

4. Scroll down to **Configure options**, and set the following:
   * **Options for sign-in identifiers**: Check **Email**.

![Cognito App Config](/images/5-Workshop/5.7-Auth-API-Gateway/cognito_app_config.png)

   * **Self-registration**: Check **Enable self-registration**.
   * **Required attributes for sign-up**: Check **email**.
   * **Add a return URL - optional**: Enter ```http://localhost``` (or skip this option).

![Cognito Options](/images/5-Workshop/5.7-Auth-API-Gateway/cognito_options.png)

5. Click the **Create user directory** button at the bottom. (Cognito will automatically generate a User Pool with its corresponding App Client).

![Cognito Create User Directory](/images/5-Workshop/5.7-Auth-API-Gateway/cognito_create_directory.png)

6. From the created User Pool's detail page, copy the following 2 parameters to configure API Gateway and Frontend in the next chapter:
   * **User Pool ID** (displayed on the overview page).
   * **App Client ID** (switch to the *App clients* section and copy the Client ID).

*(Note: If you need to change Cognito email delivery settings or other advanced features, you can edit the Authentication, Sign-up, Message templates, etc., sections after the User Pool has been created).*
