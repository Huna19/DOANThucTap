---
title : "SNS Notifications & DLQ Monitoring"
date : 2024-01-01
weight : 3
chapter : false
pre : " <b> 5.5.3. </b> "
---

### Configure SNS Topics & CloudWatch Alarm Monitoring

In this section, we will set up 2 notification channels using **Amazon SNS** to send email alerts to the operations team (Ops) and end users (User), and configure a **CloudWatch Alarm** to monitor the Dead Letter Queue (DLQ) to detect failed booking orders early.

---

#### 1. Create SNS Topic for Operations (Ops Notification)

1. Open the [Amazon SNS console](https://us-east-1.console.aws.amazon.com/sns/v3/home?region=us-east-1#/topics).
2. Click **Create topic**.

   ![SNS Create Topic Button](/images/5-Workshop/5.5-Application-Messaging/sns_create_topic_btn.jpg)

3. Configure the Topic:
   * **Type**: Select **Standard**.
   * **Name**: Enter ```booking-notification-topic```.
   * **Display name**: Enter ```Booking Ops Notifications```.

   ![SNS Ops Create](/images/5-Workshop/5.5-Application-Messaging/sns_ops_create.jpg)

4. Click **Create topic** at the bottom of the page.

   ![SNS Create Topic Button Bottom](/images/5-Workshop/5.5-Application-Messaging/sns_create_topic_btn_bottom.jpg)

5. Once the topic is created, on the topic details page, click **Create subscription**:

   ![SNS Ops Details](/images/5-Workshop/5.5-Application-Messaging/sns_ops_details.jpg)

   * **Protocol**: Select **Email**.
   * **Endpoint**: Enter the operations team email address (e.g., ```ops-team@example.com```).

   ![SNS Create Subscription](/images/5-Workshop/5.5-Application-Messaging/sns_create_subscription.jpg)

   * Click **Create subscription** at the bottom.

   ![SNS Create Subscription Button Bottom](/images/5-Workshop/5.5-Application-Messaging/sns_create_subscription_btn_bottom.jpg)

{{% notice warning %}}
After creating the Subscription, the system will send a confirmation email (Confirmation Email) to the email address you entered. You **must** go to your inbox and click the **Confirm subscription** link to activate the notification channel. If not confirmed, the system will not be able to send notifications to this email address.
{{% /notice %}}

---

#### 2. Create SNS Topic for Users (User Notification)

1. Go back to the [Amazon SNS Topics page](https://us-east-1.console.aws.amazon.com/sns/v3/home?region=us-east-1#/topics).
2. Click **Create topic**.

   ![SNS Create Topic Button](/images/5-Workshop/5.5-Application-Messaging/sns_create_topic_btn.jpg)

3. Configure the Topic:
   * **Type**: Select **Standard**.
   * **Name**: Enter ```booking-notification-topic-for-user```.
   * **Display name**: Enter ```Booking User Notifications```.

   ![SNS User Create](/images/5-Workshop/5.5-Application-Messaging/sns_user_create.jpg)

4. Click **Create topic** at the bottom.

   ![SNS Create Topic Button Bottom](/images/5-Workshop/5.5-Application-Messaging/sns_create_topic_btn_bottom.jpg)

5. On the topic details page, click **Create subscription**:

   ![SNS Ops Details](/images/5-Workshop/5.5-Application-Messaging/sns_ops_details.jpg)

   * **Protocol**: Select **Email**.
   * **Endpoint**: Enter the end-user email address (e.g., ```user@example.com```).

   ![SNS Create Subscription](/images/5-Workshop/5.5-Application-Messaging/sns_create_subscription.jpg)

   * Click **Create subscription** at the bottom.

   ![SNS Create Subscription Button Bottom](/images/5-Workshop/5.5-Application-Messaging/sns_create_subscription_btn_bottom.jpg)

6. Check your inbox and **confirm the subscription** in the same way.

---

#### 3. Create CloudWatch Alarm to Monitor DLQ

{{% notice info %}}
This CloudWatch Alarm will automatically send alerts through the SNS Ops Topic whenever a message appears in the Dead Letter Queue (DLQ). This helps the operations team immediately detect failed bookings that have exceeded the allowed retry limit.
{{% /notice %}}

1. Open the [Amazon CloudWatch console](https://us-east-1.console.aws.amazon.com/cloudwatch/home?region=us-east-1#alarmsV2:).
2. Click **Create alarm**.

   ![CloudWatch Create Alarm Button](/images/5-Workshop/5.5-Application-Messaging/cloudwatch_create_alarm_btn.jpg)

3. Click **Select metric**:
   * Select **SQS** → **Queue Metrics**.

   ![CloudWatch Select Metric Button](/images/5-Workshop/5.5-Application-Messaging/cloudwatch_select_metric_btn.jpg)
   ![CloudWatch SQS Select](/images/5-Workshop/5.5-Application-Messaging/cloudwatch_select_sqs.jpg)
   ![CloudWatch Queue Metrics](/images/5-Workshop/5.5-Application-Messaging/cloudwatch_queue_metrics.jpg)

   * Find and select the **ApproximateNumberOfMessagesVisible** metric for the ```checkout-dlq.fifo``` queue.
   * Click **Select metric**.

   ![CloudWatch DLQ Metric](/images/5-Workshop/5.5-Application-Messaging/cloudwatch_dlq_metric.jpg)

4. Configure the Alarm:
   * **Statistic**: Select **Sum**.
   * **Period**: Select **5 minutes**.
   * **Conditions**:
     * Threshold type: **Static**.
     * Whenever ApproximateNumberOfMessagesVisible is: **Greater/Equal** (>=).
     * than: Enter ```1```.
   * Click **Next**.

   ![CloudWatch DLQ Condition](/images/5-Workshop/5.5-Application-Messaging/cloudwatch_dlq_condition.jpg)

5. Configure **Notification**:
   * **Alarm state trigger**: Select **In alarm**.
   * **Select an SNS topic**: Select **Select an existing SNS topic** → choose ```booking-notification-topic``` (Ops topic created in Step 1).
   * Click **Next**.

   ![CloudWatch DLQ Notification](/images/5-Workshop/5.5-Application-Messaging/cloudwatch_dlq_notification.jpg)

6. Name the Alarm:
   * **Alarm name**: Enter ```ticket-app-checkout-dlq-alarm```.
   * **Alarm description**: Enter ```Alarm when DLQ has messages - potential lost bookings!```.

   ![CloudWatch DLQ Alarm Details](/images/5-Workshop/5.5-Application-Messaging/cloudwatch_dlq_alarm_details.jpg)

7. Click **Next** → review configurations → click **Create alarm**.

   ![CloudWatch DLQ Alarm](/images/5-Workshop/5.5-Application-Messaging/cloudwatch_dlq_alarm.jpg)

---

#### Verify Results

After completion:
1. In the CloudWatch Alarms page, confirm that the ```ticket-app-checkout-dlq-alarm``` alarm displays an **OK** state (meaning the DLQ is currently free of error messages).
2. In the SNS Topics page, confirm that both topics have subscriptions in the **Confirmed** state.

   ![Alarm Status OK](/images/5-Workshop/5.5-Application-Messaging/alarm_status_ok.jpg)
