---
title : "Tầng Giao diện"
date : 2024-01-01
weight : 4
chapter : false
pre : " <b> 5.4. </b> "
---

### Tầng Giao diện (Frontend Tier)

Trong phần này, chúng ta sẽ cấu hình lưu trữ website tĩnh của ứng dụng **Ticketing App** trên **Amazon S3** và thiết lập phân phối nội dung toàn cầu an toàn thông qua **Amazon CloudFront** sử dụng cơ chế bảo mật **Origin Access Control (OAC)**.

---

#### 1. Khởi tạo Amazon S3 Bucket cho Frontend

S3 Bucket sẽ được chặn toàn bộ quyền truy cập công cộng. Chỉ duy nhất CloudFront Distribution mới có quyền đọc dữ liệu từ Bucket này.

1. Mở [Amazon S3 console](https://s3.console.aws.amazon.com/s3/home?region=us-east-1#).
2. Click **Create bucket**.
3. Trong giao diện cấu hình **Create bucket**:
   * **Bucket name**: Đặt tên duy nhất toàn cầu theo cú pháp: ```frontend-ticket-app-<your-account-id>``` (Ví dụ: `frontend-ticket-app-123456789012`).
   * **AWS Region**: Chọn ```us-east-1``` (hoặc region bạn đang chạy lab).
   * **Object Ownership**: Chọn **ACLs disabled (recommended)**.
   * **Block Public Access settings for this bucket**:
     * Tích chọn **Block all public access** (Chặn hoàn toàn truy cập trực tiếp từ internet).

   ![S3 Bucket Name](/images/5-Workshop/5.4-Frontend-Tier/s3_create_name.png)
   ![S3 Object Ownership](/images/5-Workshop/5.4-Frontend-Tier/s3_create_ownership.png)
   ![S3 Create Button](/images/5-Workshop/5.4-Frontend-Tier/s3_create_button.png)

   * Giữ nguyên các cấu hình mặc định khác và click **Create bucket** ở cuối trang.

---

#### 2. Khởi tạo Amazon S3 Bucket cho Assets (Hình ảnh & E-tickets)

{{% notice info %}}
Ngoài Frontend Bucket, ứng dụng cần thêm một S3 Bucket riêng để lưu trữ hình ảnh trận đấu, vé điện tử (e-tickets) và các tài nguyên khác do Backend upload. Bucket này cho phép truy cập công khai để hiển thị hình ảnh trên giao diện.
{{% /notice %}}

1. Quay lại [Amazon S3 console](https://s3.console.aws.amazon.com/s3/home?region=us-east-1#) → click **Create bucket**.
2. Trong giao diện cấu hình **Create bucket**:
   * **Bucket name**: Đặt tên theo cú pháp: ```ticket-app-assets-<your-account-id>``` (Ví dụ: `ticket-app-assets-123456789012`).
   * **AWS Region**: Chọn ```us-east-1``` (hoặc region bạn đang chạy lab).
   * **Object Ownership**: Chọn **ACLs disabled (recommended)**.
   * **Block Public Access settings for this bucket**:
     * **Bỏ tích** (uncheck) ô **Block all public access** (Cho phép truy cập công khai đọc hình ảnh).
     * Tích xác nhận ô "I acknowledge that the current settings might result in this bucket and the objects within becoming public."

   ![S3 Assets Bucket Name](/images/5-Workshop/5.4-Frontend-Tier/s3_assets_create_name.png)
   ![S3 Assets Ownership](/images/5-Workshop/5.4-Frontend-Tier/s3_assets_create_ownership.png)
   ![S3 Assets Public Access](/images/5-Workshop/5.4-Frontend-Tier/s3_assets_create_public.png)

3. Click **Create bucket** ở cuối trang.
4. Sau khi bucket được tạo, vào trang chi tiết bucket → chọn tab **Permissions** → cuộn đến mục **Cross-origin resource sharing (CORS)** → click **Edit** → dán cấu hình CORS sau:
   ```json
   [
     {
       "AllowedHeaders": ["*"],
       "AllowedMethods": ["GET", "PUT", "POST"],
       "AllowedOrigins": ["*"],
       "MaxAgeSeconds": 3000
     }
   ]
   ```
5. Click **Save changes**.

   ![S3 Assets CORS](/images/5-Workshop/5.4-Frontend-Tier/s3_assets_cors.png)

---

#### 3. Khởi tạo CloudFront Distribution & Cấu hình OAC

1. Mở [Amazon CloudFront console](https://us-east-1.console.aws.amazon.com/cloudfront/v4/home?region=us-east-1#/distributions).
2. Click **Create distribution**.
3. Trong giao diện cấu hình **Create distribution**:
   * **Distribution information**:
     * **Distribution name**: Có thể nhập ```ticket-app-frontend``` hoặc để mặc định.
     * **Project type**: Chọn **Single website or app**.
   * **Origin**:
     * **Origin type**: Chọn **Amazon S3**.
     * **S3 origin**: Chọn **Browse S3** -> Chọn bucket ```frontend-ticket-app-<your-account-id>``` đã tạo ở bước trước.
     * **Origin settings**: Chọn **Use recommended origin settings**. (CloudFront sẽ tự động tạo và gán OAC, cấu hình Sign requests, và thiết lập các thông số tối ưu).

{{% notice warning %}}
Lưu ý: Bucket S3 phải là bucket thông thường (REST endpoint), **không được bật** Static Website Hosting, vì OAC không hỗ trợ Website Endpoint.
{{% /notice %}}

   ![CloudFront Origin OAC](/images/5-Workshop/5.4-Frontend-Tier/cf_oac.png)

   * **Security protections**:
     * **AWS WAF**: Chọn **Do not enable security protections** (Đối với bài lab nhằm tránh phát sinh chi phí).

   ![CloudFront WAF](/images/5-Workshop/5.4-Frontend-Tier/cf_waf.png)
   * **Default cache behavior**:
     * **Viewer protocol policy**: Chọn **Redirect HTTP to HTTPS** (Tự động chuyển hướng người dùng sang HTTPS).
     * **Allowed HTTP methods**: Chọn ```GET, HEAD, OPTIONS```.
   * **Settings**:
     * **Price class**: Chọn **Use only North America and Europe** (hoặc Price Class phù hợp để tối ưu chi phí).
     * **Default root object**: Nhập ```index.html```.

   ![CloudFront Price Class](/images/5-Workshop/5.4-Frontend-Tier/cf_price_class.png)

4. Click **Create distribution** ở dưới cùng.
5. Sau khi Distribution được tạo thành công, CloudFront sẽ hiển thị thông tin. Sao chép giá trị **Distribution domain name** (ví dụ: `dxxxxxxxxxx.cloudfront.net`). Đây là địa chỉ dùng để truy cập website sau khi quá trình triển khai hoàn tất.

   ![CloudFront Domain](/images/5-Workshop/5.4-Frontend-Tier/cf_domain.png)

---

#### 4. Cấu hình Custom Error Responses cho SPA

Vì ứng dụng Frontend được xây dựng bằng React (Single Page Application), chúng ta cần điều hướng các lỗi 403/404 về `index.html` để React tự xử lý routing.

1. Trong trang quản lý CloudFront Distribution vừa tạo, chuyển sang tab **Error pages**.
2. Click **Create custom error response**.
3. Cấu hình xử lý lỗi **403**:
   * **HTTP error code**: Chọn **403: Forbidden**.
   * **Customize error response**: Chọn **Yes**.
   * **Response page path**: Nhập `/index.html`.
   * **HTTP Response code**: Nhập **200: OK**.
   * Click **Create custom error response**.
4. Lặp lại các bước trên để cấu hình cho lỗi **404**:
   * **HTTP error code**: Chọn **404: Not Found**.
   * **Customize error response**: Chọn **Yes**.
   * **Response page path**: Nhập `/index.html`.
   * **HTTP Response code**: Nhập **200: OK**.
   * Click **Create custom error response**.

   ![CloudFront Error Pages](/images/5-Workshop/5.4-Frontend-Tier/cf_error_pages.png)

---

#### 5. Cập nhật S3 Bucket Policy

{{% notice note %}}
Sau khi CloudFront Distribution được tạo, bạn phải cập nhật lại chính sách (Bucket Policy) của S3 để cho phép dịch vụ CloudFront Principal đọc được các tệp tin trong bucket của bạn.
{{% /notice %}}

1. Khi màn hình chuyển đến trang chi tiết CloudFront Distribution vừa tạo, bạn sẽ thấy một banner màu vàng hiển thị thông báo yêu cầu cập nhật S3 Bucket Policy.
2. Click vào nút **Copy policy** ở góc phải banner.

   ![Copy S3 Policy](/images/5-Workshop/5.4-Frontend-Tier/copy_policy.png)

3. Quay lại trang chi tiết S3 Bucket ```frontend-ticket-app-<your-account-id>``` của bạn:
   * Chọn tab **Permissions**.
   * Cuộn xuống phần **Bucket policy** -> click **Edit**.
   * Dán toàn bộ nội dung JSON policy vừa copy vào khung soạn thảo.
   * Click **Save changes**.

   ![Save S3 Policy](/images/5-Workshop/5.4-Frontend-Tier/s3_policy_save.png)

---

#### 6. Cấu hình và Build mã nguồn Frontend

Trước khi upload code Frontend lên S3, chúng ta cần cấu hình để Frontend có thể giao tiếp với Cognito User Pool và API Gateway.

1. Đi vào thư mục mã nguồn Frontend trên máy tính của bạn (thư mục ```ticket-booking-frontend```).
2. Tạo hoặc chỉnh sửa file cấu hình môi trường ```.env``` trong thư mục Frontend:
   ```env
   REACT_APP_API_URL=https://ticket-app-api-url (Địa chỉ URL của API Gateway - xem ở chương 5.7)
   REACT_APP_COGNITO_USER_POOL_ID=us-east-1_xxxxx (Xem ở chương 5.7)
   REACT_APP_COGNITO_CLIENT_ID=xxxxxxxxxxxx (Xem ở chương 5.7)
   ```
3. Mở Terminal tại thư mục Frontend, chạy các lệnh sau để cài đặt thư viện và build dự án:
   ```bash
   npm install
   npm run build
   ```
   * Sau khi chạy thành công, thư mục ```build``` hoặc ```dist``` sẽ được tạo ra chứa các tệp tin tĩnh (index.html, JS, CSS, hình ảnh).

   ![Frontend Build](/images/5-Workshop/5.4-Frontend-Tier/npm_build.png)

---

#### 7. Upload mã nguồn lên S3 Frontend Bucket

1. Quay lại trang chi tiết S3 Bucket ```frontend-ticket-app-<your-account-id>``` trên AWS Console.
2. Tại tab **Objects**, click **Upload**.
3. Kéo và thả toàn bộ các tệp tin và thư mục con nằm **bên trong** thư mục ```build``` (hoặc ```dist```) vừa sinh ra ở Bước 6 vào khung upload.
   * *Lưu ý: Phải tải lên file `index.html` nằm ngay tại thư mục gốc của S3 Bucket.*

   ![S3 Uploading](/images/5-Workshop/5.4-Frontend-Tier/s3_uploading.png)

4. Click **Upload** ở cuối trang và đợi quá trình tải lên hoàn tất.

   ![S3 Upload Complete](/images/5-Workshop/5.4-Frontend-Tier/s3_uploaded_objects.png)

Sau khi upload thành công, hãy truy cập website thông qua địa chỉ Distribution domain name của CloudFront để xác nhận giao diện đã hiển thị thành công.

![Access Website via CloudFront](/images/5-Workshop/5.4-Frontend-Tier/website_access.png)

