---
title : "Introduction"
date : 2024-01-01 
weight : 1 
chapter : false
pre : " <b> 5.1. </b> "
---

#### Introduction to Ticket-App

**Ticket-App** is a multi-event online ticketing web application designed to be highly scalable, secure, and fault-tolerant. The main objective of this workshop is to guide you step-by-step to build and deploy a complete 3-tier architecture for this system on AWS by combining networking infrastructure, auto-scaling compute resources, asynchronous message queues, and high-availability database setups.

#### Workshop overview

In this workshop, you will practice building the system with the following core components:

*   **Web Frontend:** Static web UI hosted on **Amazon S3** (Static Website Hosting), distributed globally through **Amazon CloudFront** content delivery network (ready to integrate **AWS WAF** security protections).
*   **Web Backend (API Tier):** API servers running on **Amazon EC2** instances, managed and auto-scaled using **AWS Elastic Beanstalk (Web Server Environment)**. This tier receives booking requests, performs rapid validations, and pushes them to SQS.
*   **Messaging Tier:** **Amazon SQS FIFO** queue to ingest and buffer ticket bookings, guaranteeing exactly-once processing and order preservation. Integrated **Dead Letter Queue (DLQ)** to isolate failed messages.
*   **Worker Tier:** Message consumers running as **AWS Elastic Beanstalk (Web Server Environment configured for background polling)**, continuously polling SQS FIFO and writing transactions to the database.
*   **Database & Caching Tier:** Relational **RDS PostgreSQL** with **Multi-AZ** configuration for high availability and failover, combined with **RDS Proxy** connection pooling. An **ElastiCache Redis** (Primary/Replica) cluster handles session and event data caching to offload read queries.
*   **Security & Auxiliary Services:** User authentication via **Amazon Cognito**, credential management via **AWS Secrets Manager**, automatic ticket email delivery via **Amazon SES**, system monitoring using **Amazon CloudWatch**, and error notifications via **Amazon SNS**.

Detailed architecture diagram you will build in the workshop:

![overview](/images/5-Workshop/5.1-Workshop-overview/ticket_app_architecture.png)
