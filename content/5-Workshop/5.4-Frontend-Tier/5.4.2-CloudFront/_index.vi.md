---
title : "Cấu hình CloudFront & OAC"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.4.2. </b> "
---

### Cấu hình CloudFront Distribution & Bảo mật OAC

Sau khi có S3 Buckets, chúng ta sẽ thiết lập **Amazon CloudFront Distribution** làm lớp CDN biên để phân phối nội dung tĩnh. Đồng thời, cấu hình **Origin Access Control (OAC)** để đảm bảo an toàn bảo mật, chặn truy cập trực tiếp vào S3 từ internet.

---

#### 1. Khởi tạo CloudFront Distribution & Cấu hình OAC

1. Mở [Amazon CloudFront console](https://us-east-1.console.aws.amazon.com/cloudfront/v4/home?region=us-east-1#/distributions).
2. Click **Create distribution**.
3. Trong giao diện cấu hình **Create distribution**:
   * **Distribution options**:
     * **Distribution name**: Nhập ```ticket-app-frontend``` hoặc để mặc định.
     * **Project type**: Chọn **Single website or app**.

   ![CloudFront Distribution Options](/images/5-Workshop/5.4-Frontend-Tier/cf_oac.png)

   * **Domain**:
     * Chọn **Skip domain setup** (Chúng ta sẽ sử dụng tên miền mặc định do CloudFront tự phát hành).

   ![CloudFront Domain Setup](/images/5-Workshop/5.4-Frontend-Tier/cf_waf.png)

   * **Origin**:
     * **Origin type**: Chọn **Amazon S3**.
     * **S3 origin**: Chọn **Browse S3** -> Chọn đúng bucket ```frontend-ticket-app-app-<your-account-id>``` đã tạo ở bước trước.

   ![CloudFront S3 Origin](/images/5-Workshop/5.4-Frontend-Tier/cf_price_class.png)

     * **Origin settings**: Chọn **Use recommended origin settings** (CloudFront sẽ tự động tạo cấu hình OAC để kết nối an toàn tới S3 Private Bucket).


   ![CloudFront Origin Settings](/images/5-Workshop/5.4-Frontend-Tier/cf_origin_settings.jpg)

   * **Web Application Firewall (WAF)** (trong phần **Security protections**):
     * Giữ nguyên cấu hình bảo mật mặc định (AWS WAF được tự động kích hoạt sẵn để bảo vệ website trước các lỗ hổng phổ biến). Click **Next**.

   ![CloudFront Security Settings](/images/5-Workshop/5.4-Frontend-Tier/cf_waf_settings.jpg)

{{% notice note %}}
Lưu ý: Do đã chọn **Project type = Single website or app**, AWS sẽ tự động áp dụng cấu hình mặc định phù hợp cho CloudFront Distribution. Đối với workshop này, chỉ cần giữ nguyên các giá trị mặc định và nhấn **Next** để tiếp tục. Các thiết lập như Cache Behavior, Viewer Protocol Policy hoặc Allowed HTTP Methods có thể được chỉnh sửa sau nếu cần.
{{% /notice %}}

4. Click **Create distribution** ở dưới cùng.

   ![CloudFront Review and Create](/images/5-Workshop/5.4-Frontend-Tier/cf_review_2.jpg)

5. Sau khi Distribution được tạo thành công, CloudFront sẽ hiển thị thông tin. Sao chép giá trị **Distribution domain name** (ví dụ: `dxxxxxxxxxx.cloudfront.net`). Đây là địa chỉ dùng để truy cập website sau khi quá trình triển khai hoàn tất.

6. Cấu hình **Default root object** cho Distribution:
   * Do giao diện khởi tạo của CloudFront không hỗ trợ đặt Default root object trực tiếp, bạn cần vào trang chi tiết Distribution vừa tạo.
   * Tại tab **General**, cuộn xuống phần **Settings** -> click **Edit** ở góc phải.

   ![CloudFront Domain](/images/5-Workshop/5.4-Frontend-Tier/cf_domain.png)

   * Tại ô **Default root object**, nhập ```index.html```.
   * Cuộn xuống cuối trang và click **Save changes**.

   ![CloudFront Save Settings](/images/5-Workshop/5.4-Frontend-Tier/cf_save_settings.jpg)

---

#### 2. Cấu hình Custom Error Responses cho SPA

Vì ứng dụng Frontend được xây dựng bằng React (Single Page Application), chúng ta cần điều hướng các lỗi 403/404 về `index.html` để React tự xử lý routing.

1. Trong trang quản lý CloudFront Distribution vừa tạo, chuyển sang tab **Error pages**.
2. Click **Create custom error response**.
3. Cấu hình xử lý lỗi **403**:
   * **HTTP error code**: Chọn **403: Forbidden**.
   * **Customize error response**: Chọn **Yes**.
   * **Response page path**: Nhập `/index.html`.
   * **HTTP Response code**: Nhập **200: OK**.
   * Click **Create custom error response**.

   ![CloudFront Custom Error 403](/images/5-Workshop/5.4-Frontend-Tier/cf_error_403.png)

4. Lặp lại các bước trên để cấu hình cho lỗi **404**:
   * **HTTP error code**: Chọn **404: Not Found**.
   * **Customize error response**: Chọn **Yes**.
   * **Response page path**: Nhập `/index.html`.
   * **HTTP Response code**: Nhập **200: OK**.
   * Click **Create custom error response**.

   ![CloudFront Custom Error 404](/images/5-Workshop/5.4-Frontend-Tier/cf_error_404.png)

---

#### 3. Cập nhật S3 Bucket Policy

{{% notice note %}}
Sau khi CloudFront Distribution được tạo, bạn phải cập nhật lại chính sách (Bucket Policy) của S3 để cho phép dịch vụ CloudFront Principal đọc được các tệp tin trong bucket của bạn.
{{% /notice %}}

1. Tại trang quản lý CloudFront Distribution vừa tạo, chuyển sang tab **Origins**.
2. Chọn origin S3 và click **Edit**.

   ![CloudFront Origins Tab](/images/5-Workshop/5.4-Frontend-Tier/cf_origins_tab.jpg)

3. Tại giao diện **Edit origin**, cuộn xuống phần cảnh báo chính sách và click **Copy policy**.

   ![CloudFront Copy Policy](/images/5-Workshop/5.4-Frontend-Tier/cf_copy_policy.jpg)

4. Quay lại trang chi tiết S3 Bucket ```frontend-ticket-app-app-<your-account-id>``` của bạn:
   * Chọn tab **Permissions**.
   * Cuộn xuống phần **Bucket policy** -> click **Edit**.

   ![S3 Edit Policy](/images/5-Workshop/5.4-Frontend-Tier/s3_edit_policy.jpg)

5. Dán (paste) nội dung JSON policy vừa copy vào khung soạn thảo.

   ![S3 Paste Policy](/images/5-Workshop/5.4-Frontend-Tier/s3_paste_policy.jpg)

6. Cuộn xuống dưới cùng và click **Save changes**.

   ![S3 Save Policy](/images/5-Workshop/5.4-Frontend-Tier/s3_save_policy_btn.jpg)
