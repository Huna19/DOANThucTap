---
title: "Bản đề xuất"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

# Online Event Ticketing Platform
## Giải pháp AWS 3-Tier High Availability cho hệ thống đặt vé sự kiện thời gian thực

### 1. Tóm tắt điều hành
**Ticketing-App** là một nền tảng ứng dụng web đa sự kiện được thiết kế nhằm phục vụ nhu cầu đặt vé trực tuyến cho nhiều loại hình sự kiện khác nhau (liveshow ca nhạc, thể thao). Hệ thống được thiết kế đặc biệt để giải quyết triệt để bài toán nghẽn mạng và quá tải cơ sở dữ liệu bằng cơ chế xử lý đơn hàng bất đồng bộ (decoupled processing) kết hợp hàng đợi trên AWS.

---

### 2. Ý tưởng & Mục tiêu (Tuyên bố vấn đề)

#### 2.1 Bối cảnh & Bài toán
*   **Mục đích hệ thống:**
    **Ticketing-App** được phát triển như một nền tảng đặt vé sự kiện trực tuyến chuyên dụng, tối ưu hóa đặc biệt cho việc xử lý lượng truy cập cực lớn (high concurrency) phát sinh trong các đợt mở bán vé giới hạn thời gian ("flash sale").
*   **Đối tượng khách hàng:**
    Nền tảng hướng đến hai nhóm đối tượng chính: khán giả mua vé (End-users) cần một trải nghiệm đặt chỗ mượt mà, không giật lag; và các đơn vị tổ chức sự kiện (khách hàng B2B) yêu cầu một hệ thống có tính sẵn sàng cao, hoạt động ổn định để bảo vệ uy tín thương hiệu.
*   **Vấn đề giải quyết:**
    Các hệ thống bán vé truyền thống thường gặp sự cố sập máy chủ hoặc cạn kiệt kết nối cơ sở dữ liệu (database connection exhaustion) khi hàng ngàn người dùng truy cập cùng lúc. **Ticketing-App** giải quyết triệt để vấn đề này bằng kiến trúc phân rã (decoupled architecture) kết hợp hàng đợi SQS, cam kết không bỏ lỡ hay làm thất lạc bất kỳ đơn hàng nào của khách hàng.


#### 2.2 Mục tiêu cụ thể
*   **Output mong muốn:** 
    * Hạ tầng 3-tier hoàn chỉnh được tự động hóa.
    * Hệ thống giám sát (Monitoring): CloudWatch Dashboard, Logs tập trung và Alerts/Alarms tự động gửi qua email/SNS.
    * Tài liệu hướng dẫn triển khai (Workshop) chi tiết end-to-end.
*   **Tiêu chí đánh giá thành công:** 
    * Thời gian phản hồi API (Response Time) luôn dưới 200ms khi chịu tải.
    * Đảm bảo tính toàn vẹn dữ liệu: Không mất tin nhắn đặt vé, không đặt trùng vé (double-booking) nhờ SQS FIFO.
    * Hệ thống tự động co giãn (Auto Scaling) chính xác khi mô phỏng tải.

#### 2.3 Phù hợp với chương trình
*   **Use-case gắn với FCAJ / AWS:** 
    Dự án mô phỏng chính xác bài toán chịu tải cao của các hệ thống e-commerce thực tế, áp dụng trực tiếp các dịch vụ cốt lõi của AWS (Elastic Beanstalk, RDS Multi-AZ, SQS, ElastiCache, CloudFront) được đào tạo trong chương trình First Cloud AI Journey (FCAJ).
*   **Đúng trọng tâm Cloud:** 
    Giải pháp tập trung sâu vào High Availability, Security và Scalability – những triết lý cốt lõi của điện toán đám mây, hoàn toàn bám sát tiêu chí đánh giá năng lực hạ tầng Cloud.
*   **Giải pháp đề xuất:**
    Xây dựng một hệ thống đặt vé phân rã (Decoupled Architecture) trên AWS:
    1.  **Frontend:** Được lưu trữ tĩnh giá rẻ trên **S3 Static Website Hosting** để đảm bảo tải trang cực nhanh và không bị sập do lượng truy cập.
    2.  **API Gateway & Application Load Balancer (ALB):** Định tuyến và phân phối tải thông minh đến các cụm máy chủ Backend.
    3.  **Tầng Web Backend (Elastic Beanstalk):** Tiếp nhận yêu cầu mua vé của người dùng, thực hiện kiểm tra sơ bộ và đẩy ngay thông tin giao dịch vào hàng đợi **SQS FIFO** rồi trả kết quả "Đang xử lý" ngay lập tức cho client.
    4.  **Tầng Worker Backend (Elastic Beanstalk Worker):** Lấy các tin nhắn từ SQS FIFO theo thứ tự gửi, xử lý giao dịch mua vé và cập nhật trạng thái vào database PostgreSQL.
    5.  **Database & Cache:** Sử dụng **RDS Proxy** để gom cụm kết nối (connection pooling) giảm tải trực tiếp lên RDS PostgreSQL, kết hợp **ElastiCache Redis** lưu trữ session và các thông tin sự kiện/lịch trình trận đấu ít thay đổi để giảm tải đọc.
    6.  **Xác thực & Thông báo:** Tích hợp **Cognito** cho tính năng xác thực và đăng ký/đăng nhập của người dùng. Sử dụng **SNS + SES** để kích hoạt thông báo tự động và gửi email xác nhận đặt vé thành công.
*   **Lợi ích và ROI (Hiệu quả đầu tư):**
    *   **Tối ưu hóa tài nguyên & Chi phí:** Sử dụng mô hình tự động co giãn (Auto Scaling) cho phép hệ thống chỉ chạy tối thiểu 2 instances trong điều kiện bình thường và tự động mở rộng lên tối đa 4 instances khi có sự kiện mở bán vé, tránh việc lãng phí tài nguyên.
    *   **Độ tin cậy tuyệt đối:** Cơ chế SQS FIFO đảm bảo không xảy ra hiện tượng đặt trùng vé (double-booking). RDS Multi-AZ và Redis Replica đảm bảo hệ thống phục hồi lập tức sau sự cố mà không gián đoạn dịch vụ.
    *   **Bảo mật tối đa:** Toàn bộ máy chủ ứng dụng, database và cache được đặt cô lập trong các Private Subnets bảo mật cao, chỉ truy cập thông qua NAT Gateways và ALB.

---

### 3. Kiến trúc giải pháp

Hệ thống được thiết kế theo mô hình VPC chuẩn với các lớp mạng con Public/Private riêng biệt nhằm đảm bảo tính bảo mật và khả năng phân tải.

#### 3.1 Sơ đồ kiến trúc hệ thống

![Sơ đồ kiến trúc hệ thống](/images/2-Proposal/ticket_app_architecture.png)


#### 3.2 Các dịch vụ AWS sử dụng

| Phân nhóm | Dịch vụ AWS | Lý do lựa chọn & Vai trò |
| :--- | :--- | :--- |
| **Compute** | Elastic Beanstalk | Quản lý triển khai tự động hai môi trường độc lập: Backend API và Worker xử lý hàng đợi. |
| **Compute** | EC2 Instances | Chạy hệ điều hành Amazon Linux 2023, môi trường Node.js 24, cấu hình loại `t3.micro`. |
| **Compute** | Auto Scaling Group | Cấu hình co giãn tự động từ tối thiểu 2 đến tối đa 4 instances. Kích hoạt scale-out khi CPU trung bình vượt ngưỡng 70% trong 3 phút (đối với API Backend) hoặc khi số lượng Message Backlog trong hàng đợi SQS tăng cao (đối với Worker). |
| **Frontend** | Amazon S3 | Lưu trữ mã nguồn tĩnh (HTML, CSS, JS) cho trang web frontend, cấu hình Static Website Hosting để tối ưu hóa chi phí. |
| **Database** | RDS PostgreSQL | Cấu hình cơ sở dữ liệu phiên bản 18.3, loại instance `db.t3.small`, dung lượng 20GB gp3, bảo mật bằng mã hóa KMS và thiết lập Multi-AZ để dự phòng nóng. |
| **Database Proxy**| RDS Proxy | Giảm thiểu overhead kết nối thông qua Connection Pooling, bảo vệ cơ sở dữ liệu không bị cạn kiệt tài nguyên kết nối. |
| **Cache** | ElastiCache Redis | Cụm Redis phiên bản 7.0.7 gồm 2 nodes (`cache.t3.micro`) gồm 1 Primary và 1 Replica thực hiện lưu cache session và dữ liệu các sự kiện hot. |
| **Messaging** | SQS FIFO | Hàng đợi thông tin đặt vé `booking-queue.fifo` đảm bảo xử lý chính xác theo thứ tự, đi kèm `checkout-dlq.fifo` (Dead Letter Queue) để cô lập các bản ghi lỗi. |
| **Email & Noti** | SNS & SES | **SES** gửi email chứa vé điện tử cho khách hàng. **SNS** gửi thông báo vận hành hệ thống và thông báo cảnh báo lỗi. |
| **Security** | IAM, Secrets Manager, KMS | **IAM Role** thiết lập quyền tối thiểu (Least Privilege), không hard-code access key. Hạn chế tài nguyên ở Private Subnet. **Cognito** quản lý định danh. **KMS** mã hóa dữ liệu. |
| **CI/CD** | CodePipeline, CodeBuild, CodeCommit | Tự động hóa hoàn toàn quy trình đóng gói và phát hành ứng dụng (CI/CD). |
| **Monitoring** | CloudWatch | Theo dõi số liệu (Metrics) phần cứng, lưu trữ Log tập trung và kích hoạt hệ thống cảnh báo tự động (Alarms). |

---

### 4. Triển khai kỹ thuật

#### Các giai đoạn triển khai
Dự án được phân chia thành 2 giai đoạn cụ thể diễn ra trong vòng 2 tuần:
1.  **Thiết lập hạ tầng mạng, Bảo mật & Cơ sở dữ liệu (Tuần 1):** Khởi tạo VPC, phân chia Subnet Public/Private trên 2 Availability Zones, NAT Gateways và Security Group Chaining. Triển khai RDS PostgreSQL Multi-AZ + RDS Proxy, cụm ElastiCache Redis, SQS FIFO (Booking Queue & DLQ) và Cognito User Pool.
2.  **Tích hợp, Triển khai & Tự động hóa giám sát (Tuần 2):** Triển khai ứng dụng Backend & Worker lên Elastic Beanstalk, cấu hình các thuộc tính môi trường để kết nối DB/Redis/SQS và tạo S3 Static Frontend. Thiết lập luồng CI/CD qua CodePipeline và cấu hình 10 bộ CloudWatch Alarms kèm SNS gửi cảnh báo lỗi qua email.

#### Yêu cầu chuẩn bị (Prerequisites)
*   **Tài nguyên & Công cụ:** Tài khoản AWS với quyền Administrator cụ thể cho các dịch vụ sử dụng, AWS CLI đã cấu hình, Node.js 24.x và Git.
*   **Kiến thức cơ bản:** VPC Networking (Subnets, NAT Gateway, Security Groups), Elastic Beanstalk, RDS PostgreSQL, SQS/SNS, và IAM Roles & Policies.


---

### 5. Lộ trình & Mốc triển khai
*   **Tuần 1: Xây dựng hạ tầng lõi & Tầng dữ liệu/hàng đợi**
    *   Thiết kế VPC, Subnets, Gateways và thiết lập Security Groups bảo mật.
    *   Triển khai RDS PostgreSQL, RDS Proxy, ElastiCache Redis.
    *   Cấu hình SQS FIFO Queue (Booking & DLQ) và Cognito User Pool.
    *   Kiểm tra khả năng kết nối an toàn từ môi trường test tới DB và Cache.
*   **Tuần 2: Triển khai ứng dụng, CI/CD & Nghiệm thu**
    *   Phát triển logic đẩy thông tin giao dịch vào SQS (Backend API) và logic xử lý giao dịch lưu vào DB (Worker).
    *   Triển khai Backend & Worker lên Beanstalk, cấu hình S3 Static Frontend.
    *   Xây dựng CodePipeline tự động hóa deploy.
    *   Thiết lập CloudWatch Logs và 10 Alarms cảnh báo lỗi hệ thống.
    *   Chạy thử nghiệm tải giả lập (Load Testing) và bàn giao/dọn dẹp tài nguyên.


---

### 6. Ước tính ngân sách
Bảng tính chi phí chi tiết của hệ thống dựa trên công cụ ước tính [AWS Pricing Calculator](https://calculator.aws/#/estimate?id=55c11e259b0f9e28ba8a407449988fd53d95b250) (đã cấu hình sẵn cho các dịch vụ cụ thể của Ticket-App).

#### Chi phí hạ tầng hàng tháng (Môi trường Staging/Production quy mô nhỏ)

| STT | Dịch vụ AWS | Cấu hình & Tham số tính toán | Chi phí/Tháng |
| :--- | :--- | :--- | :--- |
| 1 | Elastic Beanstalk (EC2 + ALB) | 4 instances `t3.micro`, 2 Application Load Balancers | ~ $55.15 |
| 2 | RDS PostgreSQL | `db.t3.small` Multi-AZ, 20GB gp3 (Utilization 30%) | ~ $60.52 |
| 3 | ElastiCache Redis | Cụm 2 nodes `cache.t3.micro` | ~ $24.82 |
| 4 | NAT Gateways | 2 NAT Gateway, 2 Availability Zones | ~ $66.15 |
| 5 | S3 & CloudFront | 20GB Standard Storage, CloudFront Free Tier | ~ $0.53 |
| 6 | API Gateway | 1 triệu requests/tháng | ~ $1.00 |
| 7 | AWS Cognito | Tối đa 10,000 MAU | $0.00 |
| 8 | CI/CD (CodePipeline & CodeBuild) | 2 pipelines, 1 build/tháng | ~ $3.50 |
| 9 | CloudWatch & Secrets Manager & SES | Lưu trữ logs, 1 secret, 5000 emails/tháng | ~ $5.99 |
| **Tổng** | **Ước tính chi phí hàng tháng** | | **~ $217.67** |

*Lưu ý:* Chi phí hạ tầng cloud có thể giảm đáng kể xuống còn dưới **$100.00/tháng** trong môi trường Development bằng cách:
*   Loại bỏ NAT Gateways và đặt tài nguyên trong Public Subnet (tiết kiệm ~$66.15/tháng) hoặc chỉ dùng 1 NAT Gateway (tiết kiệm ~$33.00/tháng).
*   Chuyển RDS sang chế độ Single-AZ thay vì Multi-AZ (tiết kiệm ~$30.00/tháng).
*   Chỉ chạy 1 node Redis và giảm số lượng instances EC2 Beanstalk xuống tối thiểu 1 instance khi không kiểm thử tải (tiết kiệm ~$28.00/tháng).

---

### 7. Đánh giá rủi ro

#### Ma trận rủi ro

| Rủi ro xác định | Khả năng xảy ra | Mức độ ảnh hưởng | Chiến lược giảm thiểu & Phòng ngừa |
| :--- | :--- | :--- | :--- |
| **Cạn kiệt kết nối Database** | Trung bình | Rất cao | Sử dụng **RDS Proxy** để chia sẻ và duy trì kết nối tối ưu. Thực hiện Caching dữ liệu ít thay đổi qua Redis. |
| **Lỗi mất mát tin nhắn đơn hàng** | Thấp | Rất cao | Sử dụng hàng đợi **SQS FIFO** (exactly-once) để đảm bảo không mất tin nhắn, cấu hình **Dead Letter Queue (DLQ)** để giữ lại tin nhắn bị lỗi xử lý để debug sau. |
| **Chi phí hạ tầng vượt kiểm soát** | Trung bình | Trung bình | Thiết lập **CloudWatch Alarms** cảnh báo ngân sách AWS khi vượt ngưỡng 80% và 100% dự kiến. Sử dụng Auto Scaling thông minh để giảm instances ngoài giờ cao điểm. |
| **Tấn công rò rỉ dữ liệu** | Thấp | Rất cao | Không công khai bất kỳ DB hay EC2 nào ra Internet. Đặt toàn bộ tài nguyên trong Private Subnets, cấu hình bảo mật bằng Security Group Chaining nghiêm ngặt và mã hóa dữ liệu với KMS. |

#### Kế hoạch dự phòng (Contingency Plan)
*   **Trường hợp sự cố dữ liệu hoặc hạ tầng lớn:** Sử dụng tính năng Automated Backups và Snapshots của RDS để khôi phục (restore) lại cơ sở dữ liệu về thời điểm trước khi xảy ra sự cố (Point-in-Time Recovery), đảm bảo không bị mất mát dữ liệu đơn hàng quan trọng.
*   **Lỗi đồng bộ thanh toán:** Khi một đơn đặt vé bị lỗi ở tầng Worker, hệ thống tự động đưa tin nhắn lỗi vào DLQ và gửi thông báo qua SNS cho nhóm vận hành xử lý thủ công hoặc chạy script xử lý lại đơn hàng đó mà không làm nghẽn toàn bộ hệ thống đặt vé.

---

### 8. Các Luồng Xử Lý Hệ Thống & Đặc Điểm Kỹ Thuật

Hệ thống ứng dụng kiến trúc **Event-Driven Microservices** nhằm tách biệt các thao tác trực tiếp của người dùng với các tác vụ xử lý nền. Dưới đây là các luồng hoạt động chính và đặc điểm kiến trúc:

#### 8.1 Các Luồng Xử Lý Cốt Lõi (Core Processing Flows)

*   **Luồng Xác thực (Authentication):** 
    Sử dụng Amazon Cognito để quản lý định danh. Các request tới API được xác thực thông qua JWT token middleware (`aws-jwt-verify`), đảm bảo tính bảo mật và phi trạng thái (stateless) giữa client và backend.
*   **Hàng Đợi Ảo & Xử Lý Đồng Thời (Concurrency Control):** 
    Để xử lý lượng truy cập lớn khi mở bán vé, hệ thống dùng **ElastiCache Redis** làm phòng chờ ảo. Khi đặt vé, hệ thống thiết lập khóa phân tán (distributed lock) trên Redis để giữ chỗ tạm thời, giúp tránh lỗi race condition và ngăn chặn tình trạng bán vượt quá số lượng vé (overselling).
*   **Xử Lý Bất Đồng Bộ (Asynchronous Processing):** 
    Sử dụng **Amazon SQS FIFO**, các tác vụ nặng được tách khỏi luồng API chính. Việc nhận Webhook thanh toán (MoMo IPN), tạo vé điện tử, và gửi email/SMS qua SES/SNS được thực hiện ngầm bởi tầng Worker. Điều này giúp API luôn phản hồi nhanh chóng.
*   **Quản Lý Vòng Đời Đặt Chỗ & Tự Động Thu Hồi (Reservation Lifecycle):** 
    Mỗi giao dịch giữ chỗ có một khoảng thời gian giới hạn (TTL). Nếu người dùng không hoàn tất thanh toán hoặc chủ động hủy vé, hệ thống phát sinh sự kiện `RESERVATION_EXPIRED` vào SQS. Tầng Worker sẽ tiêu thụ sự kiện này, thực thi một transaction trên database (chuyển trạng thái booking thành 'cancelled', giải phóng vé), đồng thời hoàn trả số lượng vé vào kho (inventory) trên Redis và gỡ bỏ các khóa phân tán (locks). Cơ chế này đảm bảo các vé không được thanh toán sẽ ngay lập tức được trả lại hệ thống, tối đa hóa tỷ lệ lấp đầy sự kiện.

#### 8.2 Đặc Điểm Kiến Trúc (Architectural Strengths)

*   **Khả năng mở rộng & Phân rã (Scalability & Decoupling):** 
    Frontend, Backend API và Worker hoạt động độc lập, cho phép tự động co giãn (Auto Scaling) độc lập theo nhu cầu thực tế của từng tầng. Tầng Backend API tự động co giãn dựa trên ngưỡng tải CPU (scale-out khi CPU > 70%), trong khi tầng Worker co giãn theo số lượng Message Backlog trong SQS. SQS đóng vai trò làm bộ đệm (buffer) hấp thụ các đợt tải đột biến, bảo vệ database PostgreSQL khỏi tình trạng quá tải kết nối.
*   **Đảm bảo Tính nhất quán (Data Consistency):** 
    Sự kết hợp giữa cơ chế lock của Redis và khả năng xử lý tuần tự (exactly-once) của SQS FIFO đảm bảo tính nhất quán dữ liệu cho các giao dịch đặt vé. Các giao dịch lỗi được chuyển tiếp vào Dead Letter Queue (DLQ) để phục vụ việc phân tích.
*   **Công nghệ Frontend Hiện đại:** 
    Sử dụng Next.js hỗ trợ Server-Side Rendering (SSR) kết hợp với React Query để tối ưu fetching dữ liệu, cung cấp trải nghiệm ổn định và mượt mà cho người dùng kể cả khi chịu tải cao.

---

### 9. Kết quả kỳ vọng
*   **Cải tiến kỹ thuật:** 
    *   Hệ thống vận hành mượt mà, thời gian phản hồi API đặt vé (Response Time) luôn dưới 200ms nhờ cơ chế xử lý bất đồng bộ qua hàng đợi.
    *   Khả năng chịu tải tăng vượt bậc, sẵn sàng tiếp nhận hàng chục nghìn lượt đặt vé đồng thời mà không gặp tình trạng nghẽn cổ chai database.
*   **Giá trị lâu dài:**
    *   Xây dựng được kiến trúc ứng dụng 3-tier chuẩn, bảo mật, sẵn sàng mở rộng (High Availability & Scalable) trên nền tảng AWS.
    *   Giảm thiểu tối đa lỗi do con người gây ra thông qua hệ thống tự động hóa CI/CD, chuẩn bị sẵn sàng hạ tầng cho các dự án thương mại điện tử quy mô lớn tiếp theo của doanh nghiệp.
