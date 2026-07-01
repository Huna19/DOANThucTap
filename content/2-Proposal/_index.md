---
title: "Proposal"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

# Online Event Ticketing Platform
## High-Availability AWS 3-Tier Solution for Real-Time Event Booking

### 1. Executive Summary
**Ticket-App** is a multi-event web-based platform designed to handle online ticket reservations for various types of events such as live music shows, concerts, sports tournaments (including the World Cup), and large-scale entertainment events. Due to the massive spikes in traffic during ticket release windows, the system is specifically designed to prevent server crashes and database connection exhaustion through decoupled, asynchronous message processing.

The system leverages AWS cloud services to construct a standard 3-tier architecture: **AWS Elastic Beanstalk** manages automated scaling for both the API Backend and the processing Workers, **AWS SQS FIFO** guarantees exact-order, duplicate-free booking processing (exactly-once), and **RDS PostgreSQL** operates behind **RDS Proxy** alongside **ElastiCache Redis** caching. The system ensures high availability, user security via Amazon Cognito, and deployment automation via CI/CD pipelines.

---

### 2. Problem Statement
*   **Current Problem:**
    Traditional booking platforms often experience web server crashes or database connection pool exhaustion when millions of users attempt to purchase tickets simultaneously for highly anticipated events. The absence of message queues leads to lost orders, inconsistent transaction states, and a poor user experience. Additionally, manual deployments increase configuration errors and slow down software delivery.
*   **Proposed Solution:**
    Implement a decoupled architecture on AWS:
    1.  **Frontend:** Hosted on **Amazon S3 Static Website Hosting** for cost efficiency and crash-resistant page loading.
    2.  **API Gateway & Application Load Balancer (ALB):** Routes and balances incoming traffic to Backend API instances.
    3.  **Backend Tier (Elastic Beanstalk):** Receives booking requests, performs rapid preliminary validations, immediately publishes messages to **SQS FIFO**, and returns a "Pending" response to the client.
    4.  **Worker Tier (Elastic Beanstalk Worker):** Consumes messages from the SQS FIFO queue in exact order, processes bookings, and updates the database.
    5.  **Database & Caching:** Utilizes **RDS Proxy** for connection pooling to shield RDS PostgreSQL, while **ElastiCache Redis** caches user sessions and event information to offload read queries from the database.
    6.  **Auth & Notifications:** Integrates **Cognito** for managed user authentication, and uses **SNS + SES** to trigger automated alerts and ticket confirmation emails.
*   **Benefits and ROI (Return on Investment):**
    *   **Resource & Cost Optimization:** Auto Scaling configurations run a minimum of 2 instances and scale up to 4 during high-traffic ticket sales, eliminating paid idle resources.
    *   **High Reliability:** The SQS FIFO mechanism ensures zero double-bookings. RDS Multi-AZ and Redis replicas provide rapid failover without service disruption.
    *   **Strong Security:** Application servers, databases, and cache clusters are isolated in Private Subnets, accessible only through NAT Gateways and ALBs.

---

### 3. Solution Architecture

The system is deployed in a custom VPC with isolated Public and Private subnets across multiple Availability Zones.

#### 3.1 Architecture Diagram

![System Architecture](/images/2-Proposal/ticket_app_architecture.png)


#### 3.2 AWS Services Details

| Category | AWS Service | Role & Configuration Details |
| :--- | :--- | :--- |
| **Compute** | Elastic Beanstalk | Deploys and manages two isolated environments: Backend API and SQS processing Worker. |
| **Compute** | EC2 Instances | Runs Amazon Linux 2023, Node.js 24 runtime, utilizing `t3.micro` instance types. |
| **Compute** | Auto Scaling Group | Scales between a minimum of 2 instances and a maximum of 4 instances per tier based on demand. |
| **Frontend** | Amazon S3 | Serves the HTML, CSS, and JS assets using S3 Static Website Hosting for cost-effective content delivery. |
| **Database** | RDS PostgreSQL | Runs PostgreSQL version 18.3, instance class `db.t3.small`, 20GB gp3 storage, KMS-encrypted, configured with Multi-AZ for failover. |
| **Database Proxy**| RDS Proxy | Performs connection pooling to handle connections efficiently and protect the database database instance. |
| **Cache** | ElastiCache Redis | 2-node cluster of `cache.t3.micro` instances (1 Primary, 1 Replica) running Redis 7.0.7 for session store and event data caching. |
| **Messaging** | SQS FIFO | Managed queues: `booking-queue.fifo` for processing purchases sequentially, with `checkout-dlq.fifo` (Dead Letter Queue) to capture exceptions. |
| **Email & Alerts** | SNS & SES | **SES** delivers electronic tickets. **SNS** sends operational alerts and infrastructure notifications to administrators. |
| **Security** | IAM, Secrets Manager, KMS | **Cognito** manages user accounts; **Secrets Manager** secures database credentials with a 7-day auto-rotation; **KMS** encrypts at-rest data. |
| **CI/CD** | CodePipeline, CodeBuild, CodeCommit | Automates software deployment from commit to production. |
| **Monitoring** | CloudWatch | Collects logs, gathers infrastructure metrics, and runs alarms. |

---

### 4. Technical Implementation

#### Implementation Phases
The project is divided into 2 specific phases over a 2-week period:
1.  **Network Setup, Security & Database Provisioning (Week 1):** Provision the custom VPC, subnets across 2 Availability Zones, NAT Gateways, and Security Group Chaining. Deploy RDS PostgreSQL Multi-AZ with RDS Proxy, ElastiCache Redis cluster, SQS FIFO queues (Booking & DLQ), and Cognito User Pool.
2.  **App Integration, Deployment & Monitoring Automation (Week 2):** Deploy Backend API and Worker applications to Elastic Beanstalk, configure environment variables for DB/Redis/SQS connections, and set up Amazon S3 static web hosting. Construct CodePipeline CI/CD and configure 10 CloudWatch Alarms with SNS notifications.

#### Prerequisites
*   **Resources & Tools:** AWS Account with specific Administrator privileges for the services used, configured AWS CLI, Node.js 24.x, and Git.
*   **Basic Knowledge:** VPC Networking (Subnets, NAT Gateway, Security Groups), Elastic Beanstalk, RDS PostgreSQL, SQS/SNS, and IAM Roles & Policies.


---

### 5. Timeline & Milestones
*   **Week 1: Core Infrastructure, Database & Messaging Setup**
    *   Deploy VPC, subnets, route tables, and security groups.
    *   Deploy RDS PostgreSQL, RDS Proxy, and ElastiCache Redis.
    *   Configure SQS FIFO queues (Booking & DLQ) and Cognito User Pool.
    *   Validate secure connectivity within the private subnets.
*   **Week 2: Application Deployment, CI/CD Pipeline & Delivery**
    *   Develop API queue ingestion logic (Backend) and queue consumer logic (Worker).
    *   Deploy Backend and Worker codebases to Elastic Beanstalk, configure S3 Static Frontend.
    *   Automate deployment processes using CodePipeline.
    *   Establish CloudWatch Logs and trigger 10 alarms.
    *   Perform load tests and clean up test resources.

---

### 6. Budget Estimation
This estimate is based on the [AWS Pricing Calculator](https://calculator.aws/#/estimate?id=621f38b12a1ef026842ba2ddfe46ff936ed4ab01) configured for the Ticket-App.

#### Infrastructure Costs (Staging/Production Environment)

| No. | AWS Service | Configuration Details | Monthly Cost |
| :--- | :--- | :--- | :--- |
| 1 | Elastic Beanstalk + EC2 | 4 `t3.micro` instances running 24/7 (2 API, 2 Worker) | ~ $41.60 |
| 2 | RDS PostgreSQL | `db.t3.small` Multi-AZ, 20GB gp3 storage | ~ $34.00 |
| 3 | RDS Proxy | Attaches to db.t3.small database | ~ $7.30 |
| 4 | ElastiCache Redis | 2-node cluster of `cache.t3.micro` (Primary + Replica) | ~ $15.20 |
| 5 | NAT Gateways | 2 NAT Gateways operating across 2 Availability Zones | ~ $65.70 |
| 6 | SQS / SNS / SES | Less than 1 million messages monthly (mostly Free Tier) | ~ $1.50 |
| 7 | AWS Cognito | Free tier up to 50,000 Monthly Active Users (MAUs) | $0.00 |
| 8 | Secrets Manager & KMS | 1 secret storage, 3 KMS keys with auto-rotation | ~ $4.20 |
| 9 | CloudWatch & Data Transfer| Logging, metrics, and intra-VPC data transfer | ~ $8.00 |
| **Total** | **Estimated Monthly Total** | | **~ $177.50** |

*Note:* Initial local machine hardware development cost is $0.00. The cloud infrastructure cost can be trimmed to **under $50.00/month** in development environments by:
*   Running only 1 NAT Gateway instead of 2 (saves ~$32.00/month).
*   Switching RDS to Single-AZ instead of Multi-AZ (saves ~$17.00/month).
*   Reducing EC2 instances to 1 per tier and running Redis as a single node when load testing is not active.

---

### 7. Risk Assessment

#### Risk Matrix

| Identified Risk | Probability | Impact | Mitigation Strategy |
| :--- | :--- | :--- | :--- |
| **Database Connection Pool Exhaustion** | Medium | High | Utilize **RDS Proxy** connection pooling and implement ElastiCache Redis read caching. |
| **Lost or Out-of-Order Bookings** | Low | High | Use **SQS FIFO** (exactly-once processing) and redirect transaction failures to a **Dead Letter Queue (DLQ)**. |
| **Cloud Cost Spikes** | Medium | Medium | Configure **CloudWatch Budget Alarms** at 80% and 100% thresholds. Enforce ASG limits. |
| **Unauthorized Access / Breaches** | Low | High | Enforce security group chaining, keep application servers and databases in Private Subnets, and encrypt data at rest via KMS. |

#### Contingency Plan
*   **Disaster Recovery:** Use CloudFormation/CDK configurations to redeploy the entire stack in another AWS Region in the event of an outage.
*   **Failed Booking Re-processing:** If order processing fails at the Worker tier, it lands in the DLQ. Admin notifications are dispatched via SNS, and script utilities can re-ingest the message after the database state is resolved.

---

### 8. System Processing Flows & Technical Strengths

The system utilizes an **Event-Driven Microservices** architecture to decouple user-facing operations from background tasks. The core workflows and architectural characteristics include:

#### 8.1 Core Processing Flows

*   **Authentication Flow:** 
    Integrated with Amazon Cognito for identity management. API requests are authenticated using JWT validation middleware (`aws-jwt-verify`), ensuring secure and stateless authorization between the client and backend services.
*   **Virtual Waiting Room & Concurrency Control:** 
    To handle high concurrency during ticket sales, a virtual waiting room is implemented using **ElastiCache Redis**. When processing a booking, the system applies a distributed locking mechanism on Redis to reserve tickets temporarily, mitigating race conditions and preventing overselling.
*   **Asynchronous Background Processing:** 
    Using **Amazon SQS FIFO**, resource-intensive tasks are offloaded from the main API. Operations such as payment webhooks (MoMo IPN), e-ticket generation, and SES/SNS notifications are processed asynchronously by backend Workers. This ensures the primary API remains highly responsive.
*   **Reservation Lifecycle & Automated Cleanup:** 
    Reservations are granted a limited time window. If a payment is not completed or the user cancels, a `RESERVATION_EXPIRED` event is queued in SQS. The Worker tier consumes this event and performs a transactional database rollback (updating the booking status to 'cancelled' and releasing ticket rows). Simultaneously, it dynamically increments the available ticket inventory in Redis and removes the distributed locks. This automated cleanup ensures unpurchased tickets are rapidly made available to other users in the virtual queue, maximizing inventory utilization.

#### 8.2 Architectural Strengths

*   **Scalability and Decoupling:** 
    The Frontend, Backend API, and Worker tiers operate independently, allowing targeted auto-scaling based on specific load metrics. SQS acts as a buffer to handle traffic spikes without overloading the PostgreSQL database.
*   **Data Consistency:** 
    The combination of Redis distributed locks and SQS FIFO (exactly-once processing) guarantees strict data consistency across ticket reservations and payment processing, routing any failures to a Dead Letter Queue (DLQ) for debugging.
*   **Modern Frontend Stack:** 
    Built with Next.js, the frontend provides Server-Side Rendering (SSR) capabilities and leverages React Query for optimized data fetching and state management, ensuring a robust user experience under heavy load.

---

### 9. Expected Outcomes
*   **Technical Improvements:**
    *   Responsive API endpoints with response times below 200ms by offloading heavy work to background workers.
    *   No application downtime or double-bookings during ticket spikes.
*   **Long-Term Value:**
    *   Creates a reusable, production-ready, high-availability AWS 3-tier architecture template for transactional e-commerce workloads.
    *   CI/CD pipelines reduce deployment errors, raising overall code quality and release agility.