---
title: "Workshop"
date: 2024-01-01
weight: 5
chapter: false
pre: " <b> 5. </b> "
---

# Deploying a Secure, Scalable 3-Tier Ticketing Application on AWS

#### Overview

This hands-on workshop guides you step-by-step to design, configure, and deploy an enterprise-grade cloud infrastructure for a multi-event online ticketing system (**Ticketing App**). The solution leverages a highly available, secure, and auto-scaling 3-tier architecture on AWS.

Key services and components implemented in this workshop:
* **Network & Security Infrastructure:** Multi-AZ VPC design with Public/Private subnets, NAT Gateways, Security Groups, AWS WAF, and AWS Secrets Manager for credentials protection.
* **Frontend Tier:** Static website hosting on **Amazon S3**, distributed globally via **Amazon CloudFront** CDN using Origin Access Control (OAC).
* **Application & Messaging Tier:** Auto-scaled Web API and Worker servers powered by **AWS Elastic Beanstalk**. Booking transactions are decoupled and buffered asynchronously using **Amazon SQS FIFO** queues and Dead Letter Queues (DLQ) to ensure zero data loss.
* **Database & Caching Tier:** High-availability **RDS PostgreSQL Multi-AZ** deployment integrated with **RDS Proxy** for connection pooling, combined with an **ElastiCache Redis Replication Group** for fast caching.
* **Authentication & Gateway Security:** Decentralized user identity management with **Amazon Cognito User Pools** and edge-level JWT validation through **AWS API Gateway** using a custom **Cognito Authorizer**.
* **Deployment Automation (CI/CD):** End-to-end automated pipelines configured using **AWS CodeCommit**, **CodeBuild**, and **CodePipeline** for continuous integration and delivery.

#### Content

1. [Workshop Overview](5.1-Workshop-overview/)
2. [Prerequisites](5.2-Prerequiste/)
3. [Network & Security Infrastructure](5.3-Network-Security/)
4. [Frontend Tier](5.4-Frontend-Tier/)
5. [Application & Messaging Tier](5.5-Application-Messaging/)
6. [Database & Caching Tier](5.6-Database-Caching/)
7. [Authentication & API Gateway](5.7-Auth-API-Gateway/)
8. [CI/CD Pipeline](5.8-CICD-Pipeline/)
9. [Test & Validation](5.9-Test-Validation/)
10. [Resource Cleanup](5.10-Cleanup/)
