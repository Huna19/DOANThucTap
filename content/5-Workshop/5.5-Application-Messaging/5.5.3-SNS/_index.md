---
title : "SNS Notifications & DLQ Monitoring"
date : 2024-01-01
weight : 3
chapter : false
pre : " <b> 5.5.3. </b> "
---

### Configure SNS Topics & CloudWatch Alarm for DLQ Monitoring

In this section, we will set up 2 notification channels using **Amazon SNS** to send email alerts to the operations team (Ops) and end users, and configure a **CloudWatch Alarm** to monitor the Dead Letter Queue (DLQ) for early detection of failed ticket bookings.

---

#### 1. Create SNS Topic for Operations Team (Ops Notification)

1. Open the [Amazon SNS console](https://us-east-1.console.aws.amazon.com/sns/v3/home?region=us-east-1#/topics).
2. Click **Create topic**.
3. Configure the Topic:
   * **Type**: Select **Standard**.
   * **Name**: Enter ```booking-notification-topic```.
   * **Display name**: Enter ```Booking Ops Notifications```.
4. Click **Create topic**.

5. After the topic is created, on the topic details page, click **Create subscription**:
   * **Protocol**: Select **Email**.
   * **Endpoint**: Enter the operations team's email (e.g., ```ops-team@example.com```).
   * Click **Create subscription**.

{{% notice warning %}}
After creating the Subscription, the system will send a Confirmation Email to the email address you entered. You **must** check your inbox and click the **Confirm subscription** link to activate the notification channel. If not confirmed, the system will not be able to send notifications to this email.
{{% /notice %}}

![SNS Create Type](/images/5-Workshop/5.5-Application-Messaging/sns_create_type.png)
![SNS Ops Create](/images/5-Workshop/5.5-Application-Messaging/sns_ops_create.png)
![SNS Ops Details](/images/5-Workshop/5.5-Application-Messaging/sns_ops_details.png)
![SNS Create Subscription](/images/5-Workshop/5.5-Application-Messaging/sns_create_subscription.png)
![SNS Subscription Pending](/images/5-Workshop/5.5-Application-Messaging/sns_subscription_pending.png)
![SNS Email Confirm](/images/5-Workshop/5.5-Application-Messaging/sns_email_confirm.png)
![SNS Email Confirmed Page](/images/5-Workshop/5.5-Application-Messaging/sns_email_confirmed_page.png)
![SNS Subscription Confirmed](/images/5-Workshop/5.5-Application-Messaging/sns_subscription_confirmed.png)

---

#### 2. Create SNS Topic for Users (User Notification)

1. Return to the [Amazon SNS Topics](https://us-east-1.console.aws.amazon.com/sns/v3/home?region=us-east-1#/topics) page.
2. Click **Create topic**.
3. Configure the Topic:
   * **Type**: Select **Standard**.
   * **Name**: Enter ```booking-notification-topic-for-user```.
   * **Display name**: Enter ```Booking User Notifications```.
4. Click **Create topic**.

5. On the topic details page, click **Create subscription**:
   * **Protocol**: Select **Email**.
   * **Endpoint**: Enter the end user's email (e.g., ```user@example.com```).
   * Click **Create subscription**.
6. Check your email inbox and **confirm the subscription** as described above.

![SNS User Create](/images/5-Workshop/5.5-Application-Messaging/sns_user_create.png)
![SNS User Details](/images/5-Workshop/5.5-Application-Messaging/sns_user_details.png)
![SNS Dashboard](/images/5-Workshop/5.5-Application-Messaging/sns_dashboard.png)

---

#### 3. Create CloudWatch Alarm for DLQ Monitoring

{{% notice info %}}
This CloudWatch Alarm will automatically send alerts via the SNS Ops Topic whenever messages appear in the Dead Letter Queue (DLQ). This helps the operations team immediately detect when ticket bookings fail beyond the maximum allowed processing attempts.
{{% /notice %}}

1. Open the [Amazon CloudWatch console](https://us-east-1.console.aws.amazon.com/cloudwatch/home?region=us-east-1#alarmsV2:).
2. Click **Create alarm**.
3. Click **Select metric**:
   * Select **SQS** → **Queue Metrics**.
   * Find and check the **ApproximateNumberOfMessagesVisible** metric for the ```checkout-dlq.fifo``` queue.
   * Click **Select metric**.
4. Configure the Alarm:
   * **Statistic**: Select **Sum**.
   * **Period**: Select **5 minutes**.
   * **Conditions**:
     * Threshold type: **Static**.
     * Whenever ApproximateNumberOfMessagesVisible is: **Greater/Equal** (>=).
     * than: Enter ```1```.
   * Click **Next**.
5. Configure **Notification**:
   * **Alarm state trigger**: Select **In alarm**.
   * **Select an SNS topic**: Select **Select an existing SNS topic** → choose ```booking-notification-topic``` (the Ops topic created in step 1).
   * Click **Next**.
6. Name the Alarm:
   * **Alarm name**: Enter ```ticket-app-checkout-dlq-alarm```.
   * **Alarm description**: Enter ```Alarm when DLQ has messages - potential lost bookings!```.
7. Click **Next** → review the configuration → click **Create alarm**.

![CloudWatch DLQ Alarm](/images/5-Workshop/5.5-Application-Messaging/cloudwatch_dlq_alarm.png)

---

#### Verify Results

After completion:
1. On the CloudWatch Alarms page, confirm the alarm ```ticket-app-checkout-dlq-alarm``` shows **OK** status (meaning the DLQ currently has no failed messages).
2. On the SNS Topics page, confirm both topics have subscriptions in **Confirmed** status.

![Alarm Status OK](/images/5-Workshop/5.5-Application-Messaging/alarm_status_ok.png)
