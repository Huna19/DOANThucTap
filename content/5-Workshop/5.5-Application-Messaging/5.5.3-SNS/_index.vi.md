---
title : "Thông báo SNS & Giám sát DLQ"
date : 2024-01-01
weight : 3
chapter : false
pre : " <b> 5.5.3. </b> "
---

### Cấu hình SNS Topics & Giám sát CloudWatch Alarm

Trong phần này, chúng ta sẽ thiết lập 2 kênh thông báo bằng **Amazon SNS** để gửi cảnh báo qua email cho đội vận hành (Ops) và người dùng cuối (User), đồng thời cấu hình **CloudWatch Alarm** để giám sát hàng đợi lỗi (DLQ) nhằm phát hiện sớm các đơn đặt vé bị lỗi.

---

#### 1. Tạo SNS Topic cho đội vận hành (Ops Notification)

1. Mở [Amazon SNS console](https://us-east-1.console.aws.amazon.com/sns/v3/home?region=us-east-1#/topics).
2. Click **Create topic**.
3. Cấu hình Topic:
   * **Type**: Chọn **Standard**.
   * **Name**: Nhập ```booking-notification-topic```.
   * **Display name**: Nhập ```Booking Ops Notifications```.
4. Click **Create topic**.

5. Sau khi topic được tạo, tại trang chi tiết topic, click **Create subscription**:
   * **Protocol**: Chọn **Email**.
   * **Endpoint**: Nhập email của đội vận hành (ví dụ: ```ops-team@example.com```).
   * Click **Create subscription**.

{{% notice warning %}}
Sau khi tạo Subscription, hệ thống sẽ gửi một email xác nhận (Confirmation Email) đến địa chỉ email bạn đã nhập. Bạn **bắt buộc** phải vào hộp thư email và click vào link **Confirm subscription** để kích hoạt kênh thông báo. Nếu không xác nhận, hệ thống sẽ không thể gửi thông báo đến email này.
{{% /notice %}}

   ![SNS Create Type](/images/5-Workshop/5.5-Application-Messaging/sns_create_type.png)
   ![SNS Ops Create](/images/5-Workshop/5.5-Application-Messaging/sns_ops_create.png)
   ![SNS Ops Details](/images/5-Workshop/5.5-Application-Messaging/sns_ops_details.png)
   ![SNS Create Subscription](/images/5-Workshop/5.5-Application-Messaging/sns_create_subscription.png)

   *(Ghi chú: Nhớ xác nhận email và chụp ảnh màn hình Subscription Confirmed để thêm vào nhé)*

---

#### 2. Tạo SNS Topic cho người dùng (User Notification)

1. Quay lại trang [Amazon SNS Topics](https://us-east-1.console.aws.amazon.com/sns/v3/home?region=us-east-1#/topics).
2. Click **Create topic**.
3. Cấu hình Topic:
   * **Type**: Chọn **Standard**.
   * **Name**: Nhập ```booking-notification-topic-for-user```.
   * **Display name**: Nhập ```Booking User Notifications```.
4. Click **Create topic**.

5. Tại trang chi tiết topic, click **Create subscription**:
   * **Protocol**: Chọn **Email**.
   * **Endpoint**: Nhập email người dùng cuối (ví dụ: ```user@example.com```).
   * Click **Create subscription**.
6. Kiểm tra hộp thư email và **xác nhận subscription** tương tự bước trên.

   ![SNS User Create](/images/5-Workshop/5.5-Application-Messaging/sns_user_create.png)

---

#### 3. Tạo CloudWatch Alarm giám sát DLQ

{{% notice info %}}
CloudWatch Alarm này sẽ tự động gửi cảnh báo qua SNS Ops Topic mỗi khi có tin nhắn xuất hiện trong Dead Letter Queue (DLQ). Điều này giúp đội vận hành phát hiện ngay khi có đơn đặt vé bị lỗi quá số lần xử lý cho phép.
{{% /notice %}}

1. Mở [Amazon CloudWatch console](https://us-east-1.console.aws.amazon.com/cloudwatch/home?region=us-east-1#alarmsV2:).
2. Click **Create alarm**.

   ![CloudWatch Create Alarm Button](/images/5-Workshop/5.5-Application-Messaging/cloudwatch_create_alarm_btn.png)

3. Click **Select metric**:
   * Chọn **SQS** → **Queue Metrics**.

   ![CloudWatch Queue Metrics](/images/5-Workshop/5.5-Application-Messaging/cloudwatch_queue_metrics.png)

   * Tìm và tích chọn metric **ApproximateNumberOfMessagesVisible** của queue ```checkout-dlq.fifo```.

   ![CloudWatch DLQ Metric](/images/5-Workshop/5.5-Application-Messaging/cloudwatch_dlq_metric.png)

   * Click **Select metric**.

   ![CloudWatch Select Metric Button](/images/5-Workshop/5.5-Application-Messaging/cloudwatch_select_metric_btn.png)

4. Cấu hình Alarm:
   * **Statistic**: Chọn **Sum**.
   * **Period**: Chọn **5 minutes**.
   * **Conditions**:
     * Threshold type: **Static**.
     * Whenever ApproximateNumberOfMessagesVisible is: **Greater/Equal** (>=).
     * than: Nhập ```1```.
   * Click **Next**.

   ![CloudWatch DLQ Condition](/images/5-Workshop/5.5-Application-Messaging/cloudwatch_dlq_condition.png)

5. Cấu hình **Notification**:
   * **Alarm state trigger**: Chọn **In alarm**.
   * **Select an SNS topic**: Chọn **Select an existing SNS topic** → chọn ```booking-notification-topic``` (Ops topic vừa tạo ở bước 1).
   * Click **Next**.
6. Đặt tên Alarm:
   * **Alarm name**: Nhập ```ticket-app-checkout-dlq-alarm```.
   * **Alarm description**: Nhập ```Alarm when DLQ has messages - potential lost bookings!```.

   ![CloudWatch DLQ Alarm Details](/images/5-Workshop/5.5-Application-Messaging/cloudwatch_dlq_alarm_details.png)

7. Click **Next** → xem lại cấu hình → click **Create alarm**.

   ![CloudWatch DLQ Alarm](/images/5-Workshop/5.5-Application-Messaging/cloudwatch_dlq_alarm.png)

---

#### Kiểm tra kết quả

Sau khi hoàn tất:
1. Tại trang CloudWatch Alarms, xác nhận alarm ```ticket-app-checkout-dlq-alarm``` hiển thị trạng thái **OK** (nghĩa là DLQ hiện tại không có tin nhắn lỗi).
2. Tại trang SNS Topics, xác nhận cả 2 topic đều có subscription ở trạng thái **Confirmed**.

   ![Alarm Status OK](/images/5-Workshop/5.5-Application-Messaging/alarm_status_ok.png)
