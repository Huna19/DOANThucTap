---
title : "Tầng Giao diện"
date : 2024-01-01
weight : 4
chapter : false
pre : " <b> 5.4. </b> "
---

### Tầng Giao diện (Frontend Tier)

Trong phần này, chúng ta sẽ cấu hình lưu trữ website tĩnh của ứng dụng **Ticketing App** trên **Amazon S3** và thiết lập phân phối nội dung toàn cầu an toàn thông qua **Amazon CloudFront** sử dụng cơ chế bảo mật **Origin Access Control (OAC)**.

#### Các bước thực hiện:

1. **[Khởi tạo Amazon S3 Buckets](5.4.1-s3-buckets/)**
   * Khởi tạo S3 Bucket cho Frontend hosting tĩnh.
   * Khởi tạo S3 Bucket cho Assets lưu trữ hình ảnh trận đấu và vé điện tử (e-tickets), cùng cấu hình CORS.

2. **[Cấu hình CloudFront & OAC](5.4.2-cloudfront/)**
   * Tạo CloudFront Distribution sử dụng cơ chế OAC kết nối tới S3.
   * Cấu hình Default Root Object và Custom Error Responses cho SPA.
   * Cập nhật S3 Bucket Policy cho phép CloudFront truy cập.

3. **[Triển khai Frontend](5.4.3-deploy/)**
   * Cấu hình biến môi trường kết nối (.env) và build mã nguồn tĩnh React.
   * Tải tệp tĩnh lên S3 Frontend Bucket để đưa website hoạt động.
