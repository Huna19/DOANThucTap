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
2. Click **Create user pool**.
3. Cấu hình theo từng bước:
   * **Configure sign-in experience**: Chọn **Email** đăng nhập -> click **Next**.
   * **Configure security requirements**: Chọn **No MFA** -> click **Next**.
   * **Configure sign-up experience**: Giữ mặc định -> click **Next**.
   * **Configure message delivery**: Chọn **Send email with Cognito** -> click **Next**.
   * **Integrate your app**:
     * **User pool name**: Nhập ```ticket-app-user-pool```.
     * **Initial app client**: Chọn **Public client** -> Tên App client: ```ticketing-booking```.
     * **Client secret**: Chọn **Don't generate a client secret** (Bắt buộc phải tắt đối với các ứng dụng Single Page App / Frontend chạy trực tiếp trên trình duyệt như React/NextJS).
4. Click **Next** -> Click **Create user pool**.

   ![Cognito User Pool created](/images/5-Workshop/5.7-Auth-API-Gateway/cognito_userpool.png)

5. Copy lại **User Pool ID** (ví dụ: `us-east-1_xxxxx`) và **App Client ID** hiển thị ở trang tổng quan để sử dụng cho bước cấu hình API Gateway và Web Frontend.
