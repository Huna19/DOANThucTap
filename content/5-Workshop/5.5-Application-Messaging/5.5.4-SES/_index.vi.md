---
title : "Cấu hình Email (SES)"
date : 2024-01-01
weight : 4
chapter : false
pre : " <b> 5.5.4. </b> "
---

### Cấu hình Amazon Simple Email Service (SES)

Hệ thống Ticket Booking của chúng ta có một tính năng tự động gửi email thông báo cho khách hàng khi đặt vé thành công (thông qua Worker ngầm). Để làm được điều này, bạn cần cấu hình **Amazon SES** để xác thực địa chỉ email gửi đi và lấy thông tin tài khoản SMTP.

---

#### 1. Xác thực địa chỉ Email gửi (Email Identity)

1. Mở [Amazon SES console](https://us-east-1.console.aws.amazon.com/ses/home?region=us-east-1).
2. Trên menu bên trái, chọn **Identities** (dưới mục Configuration).
3. Click nút **Create identity**.

   ![SES Create Identity Button](/images/5-Workshop/5.5-Application-Messaging/ses_create_identity_btn.jpg)

4. Cấu hình Identity:
   * **Identity type**: Chọn **Email address**.
   * **Email address**: Nhập địa chỉ email thật của bạn (ví dụ: `your-email@gmail.com`). Đây sẽ là email dùng để gửi thư đi (MAIL_FROM).

   ![SES Identity Type](/images/5-Workshop/5.5-Application-Messaging/ses_create_identity_type.jpg)

5. Click **Create identity**.

{{% notice warning %}}
**Quan trọng:** AWS SES sẽ ngay lập tức gửi một email có tiêu đề *Amazon Web Services – Email Address Verification Request* đến hòm thư của bạn. Bạn **bắt buộc** phải mở email đó ra và click vào link xác nhận. Sau khi xác nhận, trạng thái Identity trong SES sẽ chuyển thành **Verified**.
{{% /notice %}}

   ![SES Identity Verified](/images/5-Workshop/5.5-Application-Messaging/ses_identity_verified.jpg)

---

#### 2. Tạo SMTP Credentials (Tài khoản gửi mail)

Để ứng dụng (Worker) có thể gọi dịch vụ SES và gửi email, chúng ta cần cấp cho nó một cặp Username/Password SMTP.

1. Vẫn ở [Amazon SES console](https://us-east-1.console.aws.amazon.com/ses/home?region=us-east-1), trên menu trái chọn **SMTP settings**.
2. Click nút **Create SMTP credentials** ở giữa trang.

   ![SES SMTP Settings](/images/5-Workshop/5.5-Application-Messaging/ses_smtp_settings.jpg)

3. Thao tác này sẽ mở ra một tab mới chuyển hướng đến giao diện IAM:
   * **IAM User Name**: Bạn có thể để mặc định hoặc đổi thành `ticket-app-smtp-user`.

   ![SES SMTP Create User](/images/5-Workshop/5.5-Application-Messaging/ses_smtp_create_user.jpg)

   * Click **Create user**.
4. Màn hình tiếp theo sẽ hiển thị **SMTP username** và **SMTP password**.
5. **CỰC KỲ QUAN TRỌNG:** Hãy click **Download Credentials** (tải file CSV) hoặc bôi đen copy cẩn thận 2 thông số này lưu ra Notepad. Bạn sẽ không thể xem lại mật khẩu này sau khi tắt màn hình!
   * Hai thông số này chính là `SMTP_USERNAME` và `SMTP_PASSWORD` mà bạn cần nhập vào cấu hình **Environment properties** của môi trường Worker trên Beanstalk (đã làm ở chương 5.5.2).

   ![SES SMTP Download](/images/5-Workshop/5.5-Application-Messaging/ses_smtp_download.jpg)

{{% notice info %}}
Trong môi trường Sandbox mặc định của SES, bạn chỉ có thể gửi email ĐẾN những địa chỉ email mà bạn đã Verify. Do đó, khi dùng thử tính năng đặt vé, hãy nhập email mà bạn đã verify ở Bước 1 (hoặc verify thêm các email khác) để nhận được thông báo nhé!
{{% /notice %}}
