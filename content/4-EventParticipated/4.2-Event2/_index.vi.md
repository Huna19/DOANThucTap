---
title: "Event 2"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 4.2. </b> "
---

# Bài thu hoạch “AWS Community Day (23/05/2026)”

### Mục Đích Của Sự Kiện

- Cập nhật các xu hướng công nghệ tiên tiến nhất trên AWS, đặc biệt là các chủ đề chuyên sâu về AI/ML, kiến trúc Multi-Agent và tối ưu hạ tầng.
- Tạo không gian kết nối (networking) và học hỏi từ các chuyên gia đến từ nhiều doanh nghiệp khác nhau.
- Thảo luận thực tế từ các case study (ví dụ: đánh giá rủi ro tín dụng startup, xây dựng Second Brain, kiến trúc CloudFront).

### Danh Sách Diễn Giả

- **Anh Tịnh**: Build second brain
- **Hải Anh**: Friendly AI Assistant with Amazon Q
- **Thịnh**: From Edge To Origin: CloudFront as Your Foundation
- **Team VIB**: 36 hrs with LotusHacks – Building UTMorpho from Idea to Reality
- **Đào Đức**: Deep dive talk: How LLM actually works
- **Cát Vy**: Enterprise-Grade Multi-Agent System: The Case of Startup Credit Scoring

### Nội Dung Nổi Bật

Sự kiện chia thành 6 chuyên đề kỹ thuật sâu sắc:

#### 1) Kỹ nghệ Ngữ cảnh & Xây dựng Second Brain (Anh Tịnh)

- **Nguyên nhân AI hoạt động kém**: Hầu hết các câu trả lời sai lệch, chung chung hoặc quá dài dòng không phải do AI kém, mà do dữ liệu đầu vào thiếu ngữ cảnh.
- **Sai lầm "The Internet Puller"**: Người dùng hay nhồi nhét toàn bộ tài liệu vào chat. Việc cung cấp dữ liệu rác làm giảm độ chính xác và gây tốn kém chi phí token.
- **Bộ khung chuẩn hóa Context**: Để AI làm "bộ não thứ hai" (Second Brain), yêu cầu đầu vào cần thiết kế như đang giao việc cho người, gồm 4 yếu tố: Mục tiêu (Goal), Thông tin liên quan (Relevant info), Ràng buộc (Constraints) và Tiêu chí thành công (Success criteria).
- **Kiến trúc hệ thống bộ nhớ**: Vận hành theo luồng: Lưu trữ (Store) → Truy xuất đúng trọng tâm (Retrieve) → Sinh kết quả (Generate) → Học hỏi (Learn).

#### 2) Trợ lý ảo Doanh nghiệp & Agentic AI (Hải Anh)

- **Thách thức dữ liệu doanh nghiệp**: Nhân sự lặp lại tác vụ thủ công tốn thời gian và tìm kiếm thông tin rải rác trên nhiều nền tảng lưu trữ khác nhau.
- **Sức mạnh của Amazon Quick Suite**: Giải pháp Agentic AI hợp nhất trải nghiệm người dùng, đẩy nhanh từ phân tích thông tin (Insight) đến thực thi (Action).
- **Năng lực tích hợp**: Kết nối trực tiếp hơn 40 nguồn dữ liệu (Data connectors), database nội bộ, tìm kiếm web và ngàn hành động từ bên thứ ba.
- **Kiểm soát Responsible AI**: Đảm bảo an toàn dữ liệu qua cơ chế quản trị (Governance), kiểm soát truy cập (Access controls) và hàng rào bảo vệ (Guardrails) tuân thủ pháp lý.

#### 3) Tối ưu hạ tầng Mạng biên với Amazon CloudFront (Thịnh)

- **Bài toán "Bill Shock"**: Với mô hình Pay-as-you-go, startup dễ gặp rủi ro tài chính khi lưu lượng tăng đột biến hoặc bị tấn công, hóa đơn có thể vọt lên $100,000.
- **Giải pháp Fixed-Price**: Gói cước cố định bao gồm CDN, WAF, Anti-DDoS, Route 53 và S3, giúp doanh nghiệp kiểm soát tài chính.
- **Sức mạnh nén dữ liệu tại Edge**: Nén tự động HTTP giúp giảm dung lượng tải xuống 82% và giảm độ trễ 81%. Tích hợp HTTP/3 (QUIC/UDP) cho phép tải song song (multiplexing) nhiều file tĩnh.
- **Bảo mật hạ tầng gốc (Origin Cloaking)**: Sử dụng Origin Access Control (OAC) hoặc Custom Headers để ẩn hoàn toàn máy chủ gốc khỏi mạng Internet.

#### 4) 36 giờ thực chiến tại LotusHacks (Team VIB)

- **Quy trình xây dựng UTMorpho**: Triển khai cấp tốc trong 36 giờ với lõi Claude Sonnet 4 chạy trên region US-East-1.
- **Rào cản kỹ thuật lớn nhất**: Đối mặt với hiện tượng AI sinh quá nhiều dữ liệu không cần thiết (AI Overgeneration) và liên tục chạm ngưỡng Token Limits.
- **Bài học rút ra**: "Real Frustration Creates Real Ideas" - Nỗi thất vọng trong thực tế tạo ra ý tưởng sản phẩm tốt. Trong Hackathon, sức bền và sự đồng bộ của đội ngũ (Team Sync) quan trọng hơn số lượng ý tưởng.

#### 5) Bản chất tính bất định của LLM (Đào Đức)

- **Lầm tưởng về Temperature = 0**: Lý thuyết cho rằng LLM sẽ ra kết quả giống nhau 100%, nhưng thực tế độ chính xác có thể dao động 15%, khoảng cách hiệu suất lần tốt/tệ nhất lên tới 70% với cùng một prompt.
- **Nguyên nhân gốc rễ**: Phép toán dấu phẩy động xử lý song song trên GPU không có tính chất kết hợp. Ngoài ra, cơ chế gộp batch (Inference batching) cũng làm thay đổi phép tính của từng request.
- **Chiến lược giảm thiểu**: Thiết kế ứng dụng chịu đựng sai số, dùng cơ chế bình chọn đa số (Majority voting) và có thể nhích Temperature lên 0.1 để tránh AI bị kẹt vòng lặp từ vựng vô tận.

#### 6) Kiến trúc Multi-Agent chuẩn Doanh nghiệp (Cát Vy)

- **Hạn chế của ngân hàng truyền thống & Single Agent**: Startup bị từ chối tín dụng do thiếu báo cáo tài chính/tài sản thế chấp. Dùng một AI duy nhất duyệt hồ sơ gây quá tải ngữ cảnh, pha loãng chuyên môn, thiếu cơ chế đối chiếu (Checks & Balances) và tạo điểm nghẽn (Single Point of Failure).
- **Giải pháp Đa đại lý (Virtual Credit Committee)**: Xây dựng hội đồng tín dụng ảo gồm: Manager, Financial Analyst, Market Analyst, Team Evaluator, Risk Assessor và Compliance.
- **Hiệu quả vận hành (ROI)**: Giảm thời gian xét duyệt từ 2-3 tuần xuống 2-4 giờ. Chi phí quyết định giảm từ ~100 triệu VNĐ xuống dưới 5 triệu VNĐ, tăng tỷ lệ duyệt thành công lên 35-45%.
- **Hạ tầng triển khai**: Đóng gói qua Docker, đưa lên Amazon ECR, tích hợp Bedrock AgentCore Runtime, kết nối qua AWS Lambda và phơi bày bằng API Gateway.

### Những Gì Học Được

- Hiểu được sự dịch chuyển từ việc sử dụng một AI model đơn lẻ sang kiến trúc Đa đại lý (Multi-Agent Paradigm) để giải quyết các bài toán phức tạp có tính phân nhánh cao.
- Nhận thức rõ hơn về tầm quan trọng của Security & Compliance (Guardrails) khi đưa AI lên môi trường Production thực tế.
- Nắm bắt được cách tối ưu hóa luồng dữ liệu truyền tải thông qua CloudFront và ứng dụng Amazon Q vào công việc.
- Hiểu được bản chất bất định của LLM và cách thiết kế hệ thống chịu lỗi khi làm việc với AI.

### Ứng Dụng Vào Công Việc

- Nghiên cứu ứng dụng **Amazon Q** vào quá trình debug và đọc hiểu tài liệu AWS để tiết kiệm thời gian.
- Thiết kế hệ thống mạng: Ưu tiên thiết lập **CloudFront** ở lớp ngoài cùng kết hợp với WAF và OAC để tăng tốc độ tải trang, ẩn máy chủ gốc và bảo mật.
- Khi thiết kế tính năng AI trong tương lai, sẽ hướng tới việc chia nhỏ logic cho từng "Agent" xử lý thay vì nhồi nhét tất cả vào một prompt duy nhất.
- Xây dựng framework viết prompt theo bộ khung 4 yếu tố: Mục tiêu, Thông tin liên quan, Ràng buộc, Tiêu chí thành công.

### Trải nghiệm trong event

Sự kiện mang lại hàm lượng kỹ thuật cực kỳ cao. Nếu Event 1 thiên về định hướng, tạo động lực học tập và tối ưu prompt cơ bản, thì Event 2 này đi thẳng vào kiến trúc hệ thống và cách các tập đoàn triển khai AI an toàn, tối ưu chi phí. Mình đặc biệt ấn tượng với case study chấm điểm tín dụng startup bằng Multi-Agent của diễn giả Cát Vy vì nó khắc họa rất rõ bức tranh Enterprise-grade AI cũng như con số ROI vô cùng thuyết phục. Ngoài ra, bài toán "Bill Shock" cùng giải pháp CloudFront cũng là một bài học thực tế rất giá trị cho các dự án sắp tới.

#### Một số hình ảnh khi tham gia sự kiện
<div style="display:flex;flex-wrap:wrap;gap:10px;align-items:flex-start">
  <img src="/images/4-EventParticipated/4.2-Event2/0af18e585985d8db819420.jpg" style="width:220px;height:auto" />
  <img src="/images/4-EventParticipated/4.2-Event2/1c14f9bc2e61af3ff67019.jpg" style="width:220px;height:auto" />
  <img src="/images/4-EventParticipated/4.2-Event2/1f91f03f27e2a6bcfff326.jpg" style="width:220px;height:auto" />
  <img src="/images/4-EventParticipated/4.2-Event2/235701fad62757790e3627.jpg" style="width:220px;height:auto" />
  <img src="/images/4-EventParticipated/4.2-Event2/3dfd2c55fb887ad6239912.jpg" style="width:220px;height:auto" />
  <img src="/images/4-EventParticipated/4.2-Event2/53ed98464f9bcec5978a14.jpg" style="width:220px;height:auto" />
  <img src="/images/4-EventParticipated/4.2-Event2/5b603dceea136b4d320223.jpg" style="width:220px;height:auto" />
  <img src="/images/4-EventParticipated/4.2-Event2/64fbaf53788ef9d0a09f21.jpg" style="width:220px;height:auto" />
  <img src="/images/4-EventParticipated/4.2-Event2/6c14edba3a67bb39e27616.jpg" style="width:220px;height:auto" />
  <img src="/images/4-EventParticipated/4.2-Event2/a39a3d34eae96bb732f824.jpg" style="width:220px;height:auto" />
  <img src="/images/4-EventParticipated/4.2-Event2/d3aafc022bdfaa81f3ce15.jpg" style="width:220px;height:auto" />
  <img src="/images/4-EventParticipated/4.2-Event2/d4174ebf9962183c417311.jpg" style="width:220px;height:auto" />
  <img src="/images/4-EventParticipated/4.2-Event2/dc4096ed4130c06e992128.jpg" style="width:220px;height:auto" />
  <img src="/images/4-EventParticipated/4.2-Event2/e4abac027bdffa81a3ce22.jpg" style="width:220px;height:auto" />
  <img src="/images/4-EventParticipated/4.2-Event2/fe4d0ce7db3a5a64032b13.jpg" style="width:220px;height:auto" />
  <img src="/images/4-EventParticipated/4.2-Event2/ff0763a9b474352a6c6525.jpg" style="width:220px;height:auto" />
</div>
