---
title : "Triển khai Frontend"
date : 2024-01-01
weight : 3
chapter : false
pre : " <b> 5.4.3. </b> "
---

### Triển khai Frontend lên S3

Trong phần cuối này, chúng ta sẽ thực hiện cấu hình các thông số kết nối, build mã nguồn ứng dụng React của Frontend thành bộ tệp tin tĩnh (static files), sau đó upload toàn bộ lên S3 Frontend Bucket để đưa website hoạt động.

---

#### 1. Cấu hình và Build mã nguồn Frontend

Trước khi upload code Frontend lên S3, chúng ta cần cấu hình để Frontend có thể giao tiếp với Cognito User Pool và API Gateway.

1. Đi vào thư mục mã nguồn Frontend trên máy tính của bạn (thư mục ```ticket-booking-frontend```).
2. Tạo hoặc chỉnh sửa file cấu hình môi trường ```.env``` trong thư mục Frontend:
   ```env
   NEXT_PUBLIC_API_URL=https://ticket-app-api-url (Địa chỉ URL của API Gateway - xem ở chương 5.7)
   NEXT_PUBLIC_COGNITO_USER_POOL_ID=us-east-1_xxxxx (Xem ở chương 5.7)
   NEXT_PUBLIC_COGNITO_CLIENT_ID=xxxxxxxxxxxx (Xem ở chương 5.7)
   NEXT_PUBLIC_COGNITO_REGION=us-east-1
   ```
3. Mở Terminal tại thư mục Frontend, chạy các lệnh sau để cài đặt thư viện và build dự án:
   ```bash
   npm install
   npm run build
   ```
   * Sau khi chạy thành công, thư mục ```out``` sẽ được tạo ra chứa các tệp tin tĩnh (index.html, JS, CSS, hình ảnh).

---

#### 2. Upload mã nguồn lên S3 Frontend Bucket

1. Quay lại trang chi tiết S3 Bucket ```frontend-ticket-app-app-<your-account-id>``` trên AWS Console.
2. Tại tab **Objects**, click **Upload**.

   ![S3 Upload Button](/images/5-Workshop/5.4-Frontend-Tier/s3_upload_btn.jpg)

3. Kéo và thả toàn bộ các tệp tin và thư mục con nằm **bên trong** thư mục ```out``` vừa sinh ra ở Bước trước vào khung upload.
   * *Lưu ý: Phải tải lên file `index.html` nằm ngay tại thư mục gốc của S3 Bucket.*

   ![S3 Upload Files](/images/5-Workshop/5.4-Frontend-Tier/s3_upload_files.jpg)

4. Click **Upload** ở cuối trang và đợi quá trình tải lên hoàn tất.

   ![S3 Execute Upload](/images/5-Workshop/5.4-Frontend-Tier/s3_upload_execute.jpg)

Sau khi upload thành công, hãy truy cập website thông qua địa chỉ Distribution domain name của CloudFront để xác nhận giao diện đã hiển thị thành công.
