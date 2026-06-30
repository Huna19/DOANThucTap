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

#### 1. Khởi tạo API Gateway HTTP API & Cấu hình Integration

1. Mở [Amazon API Gateway console](https://us-east-1.console.aws.amazon.com/apigateway/main/apis?region=us-east-1).
2. Tại mục **HTTP API**, click **Build**:
   * **API name**: Nhập ```ticket-app-api```.
   * Click **Next**.
3. Tại giao diện **Configure routes**, bấm **Next** để bỏ qua (chúng ta sẽ cấu hình chi tiết ở Bước 3).
4. Tại giao diện **Define stages**, giữ Stage name mặc định là ```$default``` và bật **Auto deploy** -> click **Next** -> click **Create**.
5. Copy địa chỉ **Invoke URL** (ví dụ: `https://xxxxxx.execute-api.us-east-1.amazonaws.com`) hiển thị tại trang chi tiết API để điền vào cấu hình Frontend `REACT_APP_API_URL`.
6. Cấu hình **Integration** kết nối đến Beanstalk Backend Load Balancer:
   * Trên menu trái, chọn **Integrations** -> click **Manage integrations** -> click **Create**.
   * **Integration type**: Chọn **HTTP proxy**.
   * **Integration method**: Chọn **ANY**.
   * **Target service**: Nhập URL gốc của Beanstalk Application Load Balancer, ví dụ: `http://ticket-app-backend-ALB-123456789.us-east-1.elb.amazonaws.com` (Tuyệt đối không thêm `/` hay `{proxy}` ở cuối).
   * Click **Create**.

   ![Create HTTP Integration](/images/5-Workshop/5.7-Auth-API-Gateway/api_integration.png)

---

#### 2. Tạo Cognito JWT Authorizer

1. Trên menu trái, chọn **Authorization** -> chuyển sang tab **Manage authorizers** -> click **Create**.
2. Cấu hình Authorizer:
   * **Authorizer type**: Chọn **JWT**.
   * **Name**: ```ticket-app-cognito-authorizer```.
   * **Identity source**: Nhập ```$request.header.Authorization``` (API Gateway sẽ tự động đọc JWT token từ header gửi kèm của client).
   * **Issuer URL**: Nhập địa chỉ: `https://cognito-idp.<AWS::Region>.amazonaws.com/<UserPoolId>` (ví dụ: `https://cognito-idp.us-east-1.amazonaws.com/us-east-1_xxxxx` - thay thế bằng AWS Region và User Pool ID thực tế của bạn).
   * **Audience**: Nhập **App Client ID** đã copy ở phần trước.
3. Click **Create**.

   ![Create JWT Authorizer](/images/5-Workshop/5.7-Auth-API-Gateway/jwt_authorizer.png)

---

#### 3. Phân loại Routes (Protected và Public)

Chúng ta cần khai báo rõ ràng các API Routes và gán quyền truy cập tương ứng.

1. Trên menu trái, chọn **Routes** -> click **Create**.
2. Tiến hành tạo lần lượt các **Public Routes** (các API không yêu cầu đăng nhập) bằng cách click **Create**:
   * Nhập Route key: ```POST /api/auth/login``` -> click **Create**. Chọn Route vừa tạo -> click **Attach integration** -> Chọn integration Beanstalk ALB đã tạo ở Bước 1. Giữ nguyên **Authorization: NONE**.
   * Thực hiện tương tự (Attach Integration và giữ Authorization: NONE) cho các route công khai sau:
     * ```POST /api/auth/register```
     * ```POST /api/auth/refresh```
     * ```GET /health```
     * ```POST /api/payments/momo/ipn``` (Webhook nhận thông báo thanh toán MoMo)
     * ```GET /api/matches``` (Xem danh sách trận đấu)
     * ```GET /api/matches/{matchId}``` (Xem chi tiết trận đấu)
3. Tạo **Protected Route** (API yêu cầu phải đăng nhập):
   * Click **Create** -> Nhập Route key: ```ANY /api/{proxy+}``` -> click **Create**.
   * Chọn route ```ANY /api/{proxy+}``` vừa tạo -> click **Attach integration** -> Chọn integration Beanstalk ALB.
   * Tại mục **Authorization**: click **Edit** -> Chọn **ticket-app-cognito-authorizer** làm Authorizer -> click **Save**.

   ![API Gateway Routes List](/images/5-Workshop/5.7-Auth-API-Gateway/api_routes.png)

---

#### 4. Cấu hình CORS (Cross-Origin Resource Sharing)

Vì API Gateway chặn các preflight `OPTIONS` requests khi sử dụng JWT Authorizer, bạn cần cấu hình CORS ở mức HTTP API để trình duyệt có thể truy cập hợp lệ.

1. Trên menu trái, chọn **CORS**.
2. Click **Configure**.
3. Điền các thông tin sau:
   * **Access-Control-Allow-Origin**: Nhập domain CloudFront của bạn (ví dụ: `https://dxxxxxxxxxx.cloudfront.net`). Bấm **Add**.
   * **Access-Control-Allow-Headers**: Nhập `content-type` và `authorization`. Bấm **Add**.
   * **Access-Control-Allow-Methods**: Chọn `GET`, `POST`, `PUT`, `DELETE`, `OPTIONS`.
   * **Access-Control-Allow-Credentials**: Chọn **Yes**.
4. Click **Save**.

   ![API Gateway CORS](/images/5-Workshop/5.7-Auth-API-Gateway/api_cors.png)
