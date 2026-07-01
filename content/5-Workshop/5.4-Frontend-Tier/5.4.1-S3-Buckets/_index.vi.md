---
title : "Khởi tạo Amazon S3 Buckets"
date : 2024-01-01
weight : 1
chapter : false
pre : " <b> 5.4.1. </b> "
---

### Khởi tạo Amazon S3 Buckets

Trong phần này, chúng ta sẽ tiến hành tạo 2 S3 Buckets phục vụ cho dự án: một Bucket làm hosting tĩnh cho website Frontend, và một Bucket lưu trữ các tài nguyên tĩnh (Assets) như hình ảnh, vé điện tử do Backend tải lên.

---

#### 1. Khởi tạo Amazon S3 Bucket cho Frontend

S3 Bucket sẽ được chặn toàn bộ quyền truy cập công cộng. Chỉ duy nhất CloudFront Distribution mới có quyền đọc dữ liệu từ Bucket này.

1. Mở [Amazon S3 console](https://s3.console.aws.amazon.com/s3/home?region=us-east-1#).
2. Click **Create bucket**.

   ![S3 Create](/images/5-Workshop/5.4-Frontend-Tier/s3_create.png)
3. Trong giao diện cấu hình **Create bucket**:
   * **Bucket name**: Đặt tên duy nhất toàn cầu theo cú pháp: ```frontend-ticket-app-app-<your-account-id>``` (Ví dụ: `frontend-ticket-app-app-123456789012`).
   * **AWS Region**: Chọn ```us-east-1``` (hoặc region bạn đang chạy lab).
   * **Object Ownership**: Chọn **ACLs disabled (recommended)**.
   * **Block Public Access settings for this bucket**:
     * Tích chọn **Block all public access** (Chặn hoàn toàn mọi truy cập trực tiếp từ internet).

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

   ![S3 Assets Bucket Name](/images/5-Workshop/5.4-Frontend-Tier/s3_assets_create_name.jpg)

   * **Object Ownership**: Chọn **ACLs disabled (recommended)**.

   ![S3 Assets Ownership](/images/5-Workshop/5.4-Frontend-Tier/s3_assets_create_ownership.jpg)

   * **Block Public Access settings for this bucket**:
     * **Bỏ tích** (uncheck) ô **Block all public access** (Cho phép truy cập công khai đọc hình ảnh).
     * Tích xác nhận ô "I acknowledge that the current settings might result in this bucket and the objects within becoming public."

   ![S3 Assets Public Access](/images/5-Workshop/5.4-Frontend-Tier/s3_assets_public_access.jpg)

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
