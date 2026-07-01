---
title: "Workshop"
date: 2024-01-01
weight: 5
chapter: false
pre: " <b> 5. </b> "
---


# Triển khai Ứng dụng Đặt vé (Ticketing App) 3 lớp Bảo mật và Tự động co giãn trên AWS

#### Tổng quan

Workshop này hướng dẫn bạn từng bước thiết kế, cấu hình và triển khai một hạ tầng đám mây chuẩn Enterprise cho ứng dụng đặt vé trực tuyến (**Ticketing App**). Hệ thống được xây dựng trên kiến trúc 3 lớp (3-tier architecture) có tính sẵn sàng cao, bảo mật nghiêm ngặt và khả năng tự động co giãn vượt trội trên nền tảng AWS.

Các dịch vụ và thành phần cốt lõi được triển khai trong workshop bao gồm:
* **Hạ tầng Mạng & Bảo mật (Network & Security):** VPC thiết kế đa vùng sẵn sàng (Multi-AZ), tích hợp Public/Private Subnets, NAT Gateway, Security Groups, AWS WAF bảo vệ tầng biên, và AWS Secrets Manager quản lý thông tin bảo mật.
* **Tầng Giao diện (Frontend Tier):** Website tĩnh lưu trữ trên **Amazon S3**, được tối ưu hóa tốc độ truy cập toàn cầu qua CDN **Amazon CloudFront** với Origin Access Control (OAC).
* **Tầng Ứng dụng & Xử lý bất đồng bộ (Application & Messaging Tier):** Máy chủ Web API và Worker chạy trên **AWS Elastic Beanstalk** có khả năng tự động co giãn (Auto Scaling). Tác vụ đặt vé được xử lý bất đồng bộ, đảm bảo tính tuần tự và không mất mát dữ liệu thông qua **Amazon SQS FIFO** và **Dead Letter Queue (DLQ)**.
* **Tầng Cơ sở dữ liệu & Bộ nhớ đệm (Database & Caching Tier):** Cơ sở dữ liệu quan hệ **RDS PostgreSQL Multi-AZ** kết hợp với **RDS Proxy** để tối ưu hóa kết nối, đi kèm bộ nhớ đệm **ElastiCache Redis Replication Group** để tăng tốc độ truy vấn.
* **Xác thực & Cổng API (Auth & API Gateway):** Quản lý người dùng tập trung bằng **Amazon Cognito User Pools**, xác thực JWT token ở mức biên bằng **AWS API Gateway (HTTP API)** sử dụng **Cognito Authorizer** trước khi forward tới Backend.
* **Tự động hóa triển khai (CI/CD Pipeline):** Quy trình tích hợp và triển khai liên tục tự động hóa hoàn toàn qua **AWS CodeCommit**, **CodeBuild**, và **CodePipeline**.

#### Nội dung

1. [Tổng quan về Workshop](5.1-Workshop-overview/)
2. [Các bước chuẩn bị](5.2-Prerequiste/)
3. [Hạ tầng Mạng & Bảo mật](5.3-Network-Security/)
4. [Tầng Giao diện](5.4-Frontend-Tier/)
5. [Tầng Ứng dụng & Xử lý bất đồng bộ](5.5-Application-Messaging/)
6. [Tầng Cơ sở dữ liệu & Bộ nhớ đệm](5.6-Database-Caching/)
7. [Xác thực & Cổng API](5.7-Auth-API-Gateway/)
8. [Tự động hóa triển khai](5.8-CICD-Pipeline/)
9. [Kiểm thử & Xác thực](5.9-Test-Validation/)
10. [Dọn dẹp tài nguyên](5.10-Cleanup/)
