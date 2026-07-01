---
title : "Configure SQS FIFO & DLQ"
date : 2024-01-01
weight : 1
chapter : false
pre : " <b> 5.5.1. </b> "
---

### Configure SQS FIFO & Dead Letter Queue (DLQ)

We need to create 2 FIFO queues: A main queue to receive booking events and a secondary queue (DLQ) to hold failed messages to prevent blocking the system.

---

#### Step-by-Step Instructions:

1. Open the [Amazon SQS console](https://us-east-1.console.aws.amazon.com/sqs/v2/home?region=us-east-1#/queues).
2. Click **Create queue**.

   ![SQS Create Queue Button](/images/5-Workshop/5.5-Application-Messaging/sqs_create_btn.jpg)

3. First, we will create the **Dead Letter Queue (DLQ)**:
   * **Type**: Select **FIFO** (Required for FIFO queues).
   * **Name**: Enter ```checkout-dlq.fifo```.
   * **Message retention period**: Set to ```4 Days```.
   * Leave other settings as default and click **Create queue** at the bottom.

   ![SQS DLQ Name](/images/5-Workshop/5.5-Application-Messaging/sqs_dlq_name.jpg)

4. Click **Create queue** again to create the main queue:
   * **Type**: Select **FIFO**.
   * **Name**: Enter ```booking-queue.fifo```.

   ![SQS Queue Name](/images/5-Workshop/5.5-Application-Messaging/sqs_queue_name.jpg)

   * **Visibility timeout**: Set to ```60 seconds```.
   * **Receive message wait time**: Set to ```0 seconds```.
   * **Content-based deduplication**: **Enabled**.

   ![SQS FIFO Settings](/images/5-Workshop/5.5-Application-Messaging/sqs_fifo_settings.jpg)

   * Scroll down to **Dead-letter queue**:
     * Select **Enabled**.
     * **Choose queue**: Select ```checkout-dlq.fifo``` created in Step 3.
     * **Maximum receives**: Enter ```3```.

   ![SQS DLQ Config](/images/5-Workshop/5.5-Application-Messaging/sqs_dlq_config.jpg)

5. Click **Create queue**.

   ![SQS Create Bottom Button](/images/5-Workshop/5.5-Application-Messaging/sqs_create_bottom_btn.jpg)
