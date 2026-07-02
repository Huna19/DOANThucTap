---
title : "API Gateway & Authorizer"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.7.2. </b> "
---

### API Gateway & JWT Authorizer

Chúng ta sử dụng **AWS API Gateway** (HTTP API) làm cổng bảo vệ các API endpoints của hệ thống thông qua **Cognito JWT Authorizer**.

---

#### 1. Khởi tạo HTTP API

1. Mở [Amazon API Gateway console](https://us-east-1.console.aws.amazon.com/apigateway/main/apis?region=us-east-1).

2. Chọn **Create API**.

![API Gateway Create API](/images/5-Workshop/5.7-Auth-API-Gateway/api_create_btn.png)

3. Dưới mục **HTTP API**, click **Build**.

4. Click **Add integration**:
   * Chọn loại Integration: **HTTP endpoint**.
   * Nhập URL của Beanstalk Application Load Balancer, ví dụ: `http://ticket-app-backend-ALB-123456789.us-east-1.elb.amazonaws.com` (Tuyệt đối không thêm `/` hay `{proxy}` ở cuối).

5. Tại mục **API name**: Nhập ```ticket-app-api```.

6. Click **Review and create** -> Click **Create**.

7. Sau khi API được tạo, copy địa chỉ **Invoke URL** hiển thị trên màn hình để điền vào cấu hình Frontend `NEXT_PUBLIC_API_URL`.

![Create HTTP API](/images/5-Workshop/5.7-Auth-API-Gateway/api_integration.png)

---

#### 2. Tạo Cognito JWT Authorizer

1. Trên menu trái, chọn **Authorization** -> chuyển sang tab **Manage authorizers** -> click **Create**.

2. Chọn Authorizer type là **JWT**.

3. Điền các thông tin sau:
   * **Name**: ```ticket-app-cognito-authorizer```.
   * **Identity source**: Nhập ```$request.header.Authorization```.
   * **Issuer URL**: Nhập địa chỉ Cognito theo chuẩn `https://cognito-idp.<AWS::Region>.amazonaws.com/<UserPoolId>` (thay bằng Region và User Pool ID của bạn).
   * **Audience**: Nhập **App Client ID**.

4. Click **Create**.

![Create JWT Authorizer](/images/5-Workshop/5.7-Auth-API-Gateway/jwt_authorizer.png)

---

#### 3. Tạo Routes và gắn Authorizer

> **💡 Lưu ý:** Route cụ thể (Exact) luôn được ưu tiên xử lý trước Route dùng tham số tham lam `{proxy+}`. Biến `{proxy+}` bắt buộc phải có phần đuôi nên sẽ không khớp với `/api` hoặc `/`.

1. Trên menu trái, chọn **Routes** -> click **Create route**.

2. Khai báo lần lượt các **Public Routes** (Không cần đăng nhập):
   * Khai báo Method và Path (VD: `POST` và `/api/auth/login`) -> click **Create**.

![API Gateway Create Route](/images/5-Workshop/5.7-Auth-API-Gateway/api_routes.png)

   * Mở Route vừa tạo, kiểm tra xem Integration đã được Attach vào HTTP endpoint (ALB) hay chưa. (Nếu chưa, chọn Attach integration).
   * Chuyển sang mục **Authorization**, đảm bảo đang chọn **NONE**.
   * Tạo tương tự cho các public routes sau:
     * ```POST /api/auth/register```
     * ```POST /api/auth/refresh```
     * ```GET /health```
     * ```POST /api/payments/momo/ipn```
     * ```GET /api/matches```
     * ```GET /api/matches/{matchId}```

3. Tạo **Protected Route** (Yêu cầu đăng nhập):
   * Khai báo Method là **ANY** và Path là `/api/{proxy+}` -> click **Create**.
   * Đảm bảo Route đã attach tới HTTP endpoint (ALB).
   * Chuyển sang mục **Authorization** -> Chọn **ticket-app-cognito-authorizer**.

---

#### 4. Cấu hình CORS

AWS khuyến nghị cấu hình CORS ở cấp HTTP API, thay vì tự xử lý request OPTIONS trong backend.

1. Trên menu trái, chọn **CORS**.

2. Cấu hình các mục sau:
   * **Allowed Origins**: Nhập domain CloudFront (ví dụ: `https://dxxxxxxxxxx.cloudfront.net`). Bấm Add.
   * **Allowed Headers**: Nhập `authorization`, `content-type`. Bấm Add.
   * **Allowed Methods**: Chọn `GET`, `POST`, `PUT`, `DELETE`, `OPTIONS`.
   * **Credentials**: Chọn **Yes** (Bắt buộc khai báo Allowed Origins cụ thể ở trên).
   * **Max age**: `300`.

![API Gateway CORS](/images/5-Workshop/5.7-Auth-API-Gateway/api_cors.png)

3. Click **Save**.
