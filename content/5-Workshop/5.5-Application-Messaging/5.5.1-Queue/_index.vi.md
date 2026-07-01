---
title : "Cấu hình SQS FIFO & DLQ"
date : 2024-01-01
weight : 1
chapter : false
pre : " <b> 5.5.1. </b> "
---

### Cấu hình SQS FIFO & Dead Letter Queue (DLQ)

Chúng ta cần tạo 2 hàng đợi dạng FIFO: Một hàng đợi chính để nhận các sự kiện đặt vé và một hàng đợi phụ (DLQ) chứa các tin nhắn lỗi quá số lần xử lý nhằm tránh làm tắc nghẽn hệ thống.

---

#### Các bước thực hiện:

1. Mở [Amazon SQS console](https://us-east-1.console.aws.amazon.com/sqs/v2/home?region=us-east-1#/queues).
2. Click **Create queue**.

   ![SQS Create Queue Button](/images/5-Workshop/5.5-Application-Messaging/sqs_create_btn.jpg)

3. Đầu tiên, chúng ta sẽ tạo hàng đợi lỗi **Dead Letter Queue (DLQ)** trước:
   * **Type**: Chọn **FIFO** (Bắt buộc đối với tất cả hàng đợi FIFO).
   * **Name**: Nhập ```checkout-dlq.fifo```.
   * Cấu hình **Message retention period**: Đặt là ```4 Days``` (Giữ tin nhắn lỗi tối đa 14 ngày).
   * Giữ nguyên các cài đặt còn lại và click **Create queue** ở cuối trang.

   ![SQS DLQ Name](/images/5-Workshop/5.5-Application-Messaging/sqs_dlq_name.jpg)

4. Click tiếp **Create queue** ở giao diện chính để tạo hàng đợi chính:
   * **Type**: Chọn **FIFO**.
   * **Name**: Nhập ```booking-queue.fifo```.

   ![SQS Queue Name](/images/5-Workshop/5.5-Application-Messaging/sqs_queue_name.jpg)

   * **Visibility timeout**: Đặt là ```60 seconds``` (Thời gian này đảm bảo Worker có đủ thời gian xử lý xong tin nhắn trước khi nó hiển thị lại cho các instance khác).
   * **Receive message wait time**: Đặt là ```0 seconds```.
   * **Content-based deduplication**: **Bật (Enabled)**.

   ![SQS FIFO Settings](/images/5-Workshop/5.5-Application-Messaging/sqs_fifo_settings.jpg)

   * Cuộn xuống mục **Dead-letter queue**:
     * Chọn **Enabled**.
     * **Choose queue**: Chọn ```checkout-dlq.fifo``` vừa tạo ở Bước 3.
     * **Maximum receives**: Nhập ```3```.

   ![SQS DLQ Config](/images/5-Workshop/5.5-Application-Messaging/sqs_dlq_config.jpg)

5. Click **Create queue**.

   ![SQS Create Bottom Button](/images/5-Workshop/5.5-Application-Messaging/sqs_create_bottom_btn.jpg)
