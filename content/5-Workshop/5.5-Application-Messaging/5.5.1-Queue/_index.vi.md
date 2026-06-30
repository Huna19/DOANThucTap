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
3. Đầu tiên, chúng ta sẽ tạo hàng đợi lỗi **Dead Letter Queue (DLQ)** trước:
   * **Type**: Chọn **FIFO** (Bắt buộc đối với tất cả hàng đợi FIFO).
   * **Name**: Nhập ```checkout-dlq.fifo```.
   * Giữ nguyên mọi cài đặt mặc định và click **Create queue** ở cuối trang.

   ![SQS Create Queue Button](/images/5-Workshop/5.5-Application-Messaging/sqs_create_btn.png)
   ![SQS DLQ Name](/images/5-Workshop/5.5-Application-Messaging/sqs_dlq_name.png)

4. Click tiếp **Create queue** ở giao diện chính để tạo hàng đợi chính:
   * **Type**: Chọn **FIFO**.
   * **Name**: Nhập ```booking-queue.fifo```.
   * **Visibility timeout**: Đặt là ```60 seconds``` (Thời gian này đảm bảo Worker có đủ thời gian xử lý xong tin nhắn trước khi nó hiển thị lại cho các instance khác).
   * **Content-based deduplication**: **Bật (Enabled)**.
   * Cuộn xuống mục **Dead-letter queue**:
     * Chọn **Enabled**.
     * **Choose queue**: Chọn ```checkout-dlq.fifo``` vừa tạo ở Bước 3.
     * **Maximum receives**: Nhập ```3```.
   * Cấu hình **High throughput FIFO queue**: Bật (Enabled) theo như khuyến nghị.

   ![SQS Queue Name](/images/5-Workshop/5.5-Application-Messaging/sqs_queue_name.png)
   ![SQS FIFO Settings](/images/5-Workshop/5.5-Application-Messaging/sqs_fifo_settings.png)
   ![SQS DLQ Config](/images/5-Workshop/5.5-Application-Messaging/sqs_dlq_config.png)
   ![SQS Create Bottom Button](/images/5-Workshop/5.5-Application-Messaging/sqs_create_bottom_btn.png)

5. Click **Create queue**.

   *(Ghi chú: Bạn nhớ chụp lại màn hình SQS Queue Details thành công và lưu thành `sqs_queue_details.png` để chèn vào nhé)*
