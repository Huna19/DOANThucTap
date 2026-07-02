---
title: "Event 3"
date: 2024-01-01
weight: 3
chapter: false
pre: " <b> 4.3. </b> "
---

# Bài thu hoạch “FCAJ Meetup (13/06/2026)”

### Mục Đích Của Sự Kiện

- Cung cấp bức tranh thực tế trần trụi về công việc của các Kỹ sư (DevOps, Data Analytics) tại các doanh nghiệp và tập đoàn đa quốc gia (MNC), xóa bỏ những lầm tưởng phổ biến của sinh viên.
- Đi sâu vào văn hóa doanh nghiệp, các tiêu chuẩn làm việc toàn cầu và định hướng lộ trình phát triển sự nghiệp bền vững, từ lúc mới vào nghề đến khi trở thành chuyên gia.
- Truyền cảm hứng và hướng dẫn cách tận dụng bệ phóng từ các cộng đồng công nghệ (AWS) để thăng tiến và lan tỏa giá trị.

### Danh Sách Diễn Giả

- **Anh Trọng H. Trương** (DevOps Engineer @ Endava Vietnam): “What does a DevOps Engineer really do?”
- **Anh Đạt Phạm** (Data Analytics Engineer) & **Anh Cường Nguyễn** (Process Engineer): “Câu chuyện thực tế đến văn hóa tại tập đoàn đa quốc gia”
- **Anh Danh Hoàng Hiếu Nghị** (AI Engineer): “From First Cloud AI Journey to AWS Partner”
- **Đinh Trung Kiên & Nguyễn Minh Thọ**: “A scalable URL shortening service on AWS”

### Nội Dung Nổi Bật

Sự kiện gồm 4 phần trình bày cực kỳ "thực chiến":

#### 1) Đinh Trung Kiên & Nguyễn Minh Thọ — A scalable URL shortening service on AWS

- **Mục đích**: Giải quyết bài toán System Design kinh điển: Xây dựng dịch vụ rút gọn URL có khả năng mở rộng tốt, bảo mật cao và tối ưu độ trễ, thay vì một bản MVP đơn giản.
- **Rủi ro của kiến trúc "Cơ bản"**: Kiến trúc Frontend → Backend → Database gặp nhiều vấn đề: Điểm nghẽn cục bộ (SPOF), khó mở rộng, độ trễ đọc cao và dễ bị tấn công do thiếu lớp bảo vệ ở mạng biên.
- **Kiến trúc hệ thống thực tế trên AWS**:
  - **Lớp Bảo vệ & Phân phối (Edge Layer)**: Dùng Amazon CloudFront + AWS WAF để chặn truy cập độc hại, phân phối nội dung tĩnh từ Amplify.
  - **Lớp Ứng dụng (App Layer)**: Backend container hóa chạy trên Amazon ECS (Fargate), dùng ALB điều phối traffic vào Private Subnet.
- **Cơ chế Sinh Key Độc lập (KGS)**: Tối ưu hiệu suất bằng cách dùng một service chạy ngầm tạo sẵn các đoạn mã ngắn và đẩy vào hàng đợi Redis (lệnh `LPUSH`), thay vì sinh mã on-demand.
- **Luồng Ghi (Create Flow)**: Backend lấy mã có sẵn từ Redis (lệnh `RPOP`), gắn với URL gốc và ghi vào DynamoDB. Không có độ trễ sinh mã.
- **Luồng Đọc (Cache-aside)**: Tìm kiếm trong Amazon ElastiCache for Redis trước. Nếu Cache miss mới gọi DynamoDB và cập nhật lại vào Cache, giảm tải cực mạnh cho database.

#### 2) Trọng H. Trương — What does a DevOps Engineer really do?

- **Lầm tưởng vs. Thực tế**: Mọi người thường nghĩ DevOps chỉ là viết CI/CD pipeline, gõ lệnh Docker/K8s, hay "anh hùng" sửa lỗi server nửa đêm. Thực tế, phạm vi công việc xoay quanh hệ thống nhiều hơn: trực on-call, xử lý sự cố (incident handling), quản lý phân quyền, điều tra chi phí và làm rõ quyền sở hữu vấn đề (Ownership clarification).
- **Học gì trước tiên**: Đừng chạy theo tool vì tool sẽ luôn thay đổi. Hãy nắm thật chắc nền tảng (Fundamentals): Linux, Networking, Git, Containers và một ngôn ngữ lập trình (Python/Golang).
- **Bài học "xương máu"**: Copy lệnh trên mạng không có nghĩa là bạn hiểu nó. Luôn hỏi "Tại sao" trước khi hỏi "Làm thế nào". Giao tiếp là kỹ năng cốt lõi của DevOps. Hãy dùng AI để nâng cao kỹ năng chứ đừng để AI "tắt" tư duy của mình.

#### 3) Đạt Phạm & Cường Nguyễn — Câu chuyện thực tế & Văn hóa MNC

- **Kỹ năng sống còn**: Để làm việc ở MNC, ngoài kỹ thuật cứng còn bắt buộc phải có Tư duy phản biện, Kỹ năng giao tiếp, Giải quyết vấn đề và đặc biệt là "Kể chuyện với dữ liệu" (Data Storytelling).
- **Mô hình 5 cấp độ sự nghiệp**: Follower (Thực thi) → Learner (Học chủ động) → Problem Solver (Tự giải quyết trọn vẹn) → System Thinker (Nhìn bức tranh toàn cảnh, tối ưu dài hạn) → Super Star (Định hướng chiến lược và dẫn dắt).
- **Giải mã Văn hóa Doanh nghiệp**: Ở MNC công nghệ, văn hóa "No-Blame Post-Mortem" rất nổi bật: khi có lỗi, đội ngũ tập trung tìm nguyên nhân rễ để sửa hệ thống chứ không đổ lỗi cá nhân.
- **Triết lý "Đúng Việc"**: 3 trụ cột: Làm Người (quản trị nội tâm), Làm Nghề (phụng sự bằng chuyên môn) và Làm Dân (trách nhiệm quốc gia, di sản công nghệ).

#### 4) Danh Hoàng Hiếu Nghị — From First Cloud AI Journey to AWS Partner

- **Lộ trình 8 bước**: Bắt đầu từ sự tò mò (Student Curiosity) → Tìm đúng môi trường (First Cloud AI Journey) → Học qua thực hành (Hands-on Labs) → Thể hiện năng lực (Portfolio) → Trở thành AWS Partner → Lan tỏa lại cộng đồng (Share Back).
- **Sức mạnh cộng đồng**: Có việc làm mới là khởi đầu. Dấn thân vào cộng đồng (AWS Student Builder Group, AWS Community Builder) mang lại mạng lưới quan hệ (network) tuyệt vời và hỗ trợ thiết thực: voucher thi chứng chỉ, AWS Credits, swags.

### Những Gì Học Được

- **Nhận thức rõ ràng**: Công cụ thay đổi liên tục, chỉ có nền tảng vững chắc (Fundamentals) và tư duy hệ thống (System Thinking) mới giúp kỹ sư đi đường dài.
- **Bước đệm vào MNC**: Chuyển đổi tư duy từ "Làm được việc" sang "Làm đúng chuẩn", kết hợp tinh thần "No-Blame" để liên tục cải tiến bản thân và hệ thống.
- **Tầm quan trọng của đóng góp**: Chuyên môn kỹ thuật kết hợp với sự hỗ trợ từ cộng đồng công nghệ sẽ tạo ra một bệ phóng mạnh mẽ cho lộ trình sự nghiệp.
- **Tối ưu kiến trúc (System Design)**: Học được tư duy Separation of Concerns (tách biệt luồng Đọc/Ghi), Defense at the Edge (bảo vệ ở mạng biên) và chiến lược Pre-computation over On-demand (tính toán trước để tối ưu độ trễ).

### Ứng Dụng Vào Công Việc

- **Tự học & Thực hành**: Cai nghiện copy-paste lệnh máy móc. Khi dùng AI hỗ trợ viết script/cấu hình, tự ép bản thân phân tích và hiểu rõ từng dòng lệnh.
- **Nâng cấp tư duy đồ án**: Áp dụng mindset System Thinker vào dự án thực tập thay vì chỉ làm Follower. Không chỉ code cho chạy, mà phải tối ưu hiệu suất, lường trước rủi ro và rèn luyện báo cáo tiến độ rõ ràng.
- **Phát triển thương hiệu cá nhân**: Lên kế hoạch tham gia tích cực AWS Student Builder Group để tích lũy dự án vào Portfolio và định hướng xây dựng cộng đồng trong tương lai.
- **Áp dụng Cache-aside Pattern**: Sử dụng Redis vào các dự án cá nhân/đồ án để tối ưu tốc độ phản hồi cho các API có tần suất đọc cao.
- **Decouple tác vụ nặng**: Học cách tách biệt các tác vụ nặng ra khỏi luồng xử lý chính bằng các worker chạy ngầm, chuẩn bị sẵn dữ liệu để luồng chính xử lý mượt mà hơn.

#### Một số hình ảnh khi tham gia sự kiện
<div style="display:flex;flex-wrap:wrap;gap:10px;align-items:flex-start">
  <img src="/images/4-EventParticipated/4.3-Event3/02fd3145e69867c63e892.jpg" style="width:220px;height:auto" />
  <img src="/images/4-EventParticipated/4.3-Event3/50400dfdda205b7e02317.jpg" style="width:220px;height:auto" />
  <img src="/images/4-EventParticipated/4.3-Event3/7223549d8340021e5b5110.jpg" style="width:220px;height:auto" />
  <img src="/images/4-EventParticipated/4.3-Event3/8319bea7697ae824b16b8.jpg" style="width:220px;height:auto" />
  <img src="/images/4-EventParticipated/4.3-Event3/92acc71710ca9194c8db1.jpg" style="width:220px;height:auto" />
  <img src="/images/4-EventParticipated/4.3-Event3/af6eaed3790ef850a11f5.jpg" style="width:220px;height:auto" />
  <img src="/images/4-EventParticipated/4.3-Event3/dba02f1ef8c3799d20d26.jpg" style="width:220px;height:auto" />
  <img src="/images/4-EventParticipated/4.3-Event3/ed911328c4f545ab1ce49.jpg" style="width:220px;height:auto" />
  
</div>
