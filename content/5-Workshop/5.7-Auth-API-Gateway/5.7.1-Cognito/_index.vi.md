---
title : "Cognito User Pool"
date : 2024-01-01
weight : 1
chapter : false
pre : " <b> 5.7.1. </b> "
---

### Quản lý định danh với Amazon Cognito

Cognito sẽ quản lý việc đăng ký tài khoản, đăng nhập và tự động cấp mã Access Token dạng JWT cho Client.

---

#### Các bước thực hiện:

1. Mở [Amazon Cognito console](https://us-east-1.console.aws.amazon.com/cognito/v2/home?region=us-east-1#).

2. Chọn **User pools** -> Click **Create user pool** (Giao diện mới: **Set up resources for your application**).

![Cognito Create User Pool](/images/5-Workshop/5.7-Auth-API-Gateway/cognito_create_btn.png)

3. Trong phần **1. Tell us about your application** -> **Define your application**:
   * **Application type**: Chọn **Single-page application (SPA)** *(Dành cho ứng dụng web như React, tự động cấu hình không dùng Client Secret)*.
   * **Name your application**: Nhập ```ticket-app-user-pool```.

4. Kéo xuống phần **Configure options**, chọn các thiết lập sau:
   * **Options for sign-in identifiers**: Tích chọn **Email**.

![Cognito App Config](/images/5-Workshop/5.7-Auth-API-Gateway/cognito_app_config.png)

   * **Self-registration**: Tích chọn **Enable self-registration** (Cho phép user tự đăng ký tài khoản).
   * **Required attributes for sign-up**: Tích chọn **email**.
   * **Add a return URL - optional**: Nhập ```http://localhost``` (hoặc bỏ trống tuỳ chọn này).

![Cognito Options](/images/5-Workshop/5.7-Auth-API-Gateway/cognito_options.png)

5. Click nút **Create user directory** ở cuối trang. (Cognito sẽ tự động khởi tạo hệ thống quản lý user và App Client).

![Cognito Create User Directory](/images/5-Workshop/5.7-Auth-API-Gateway/cognito_create_directory.png)

6. Từ trang chi tiết của User Pool vừa tạo, bạn copy lại 2 thông số sau để dùng cho bài sau (cấu hình API Gateway và Frontend):
   * **User Pool ID** (hiển thị ngay ở trang tổng quan).
   * **App Client ID** (chuyển sang mục *App clients*, copy Client ID).

*(Lưu ý: Nếu cần thay đổi cấu hình gửi email Cognito hoặc các tính năng nâng cao khác, bạn có thể chỉnh sửa tại các mục Authentication, Sign-up, Message templates... sau khi User Pool đã được tạo).*
