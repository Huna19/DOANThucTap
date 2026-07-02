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
**Ticketing-App** is a multi-event web application platform designed to handle online ticket reservations for various events (e.g., live concerts, sports). The system is specifically engineered to resolve network bottlenecks and database overload by utilizing an asynchronous decoupled processing mechanism and message queuing on AWS.

---

### 2. Concept & Objectives (Problem Statement)

#### 2.1 Context & Problem
*   **System Purpose:**
    **Ticketing-App** is a dedicated online event ticketing platform designed specifically to handle high concurrency and traffic spikes during time-limited ticket releases ("flash sale" events).
*   **Target Audience:**
    The platform serves two primary groups: end-users (ticket buyers) who demand a seamless and lag-free booking experience, and event organizers (B2B clients) who require a highly stable, crash-free system to protect their brand reputation.
*   **Problem Statement:**
    Traditional ticketing platforms frequently suffer from server crashes or database connection exhaustion when thousands of users attempt to purchase tickets simultaneously. **Ticketing-App** resolves this bottleneck through a decoupled architecture integrated with message queues, ensuring that no booking requests are dropped or lost.


#### 2.2 Specific Goals
*   **Desired Output:** 
    * A fully automated 3-tier cloud infrastructure.
    * A comprehensive Monitoring system: CloudWatch Dashboards, centralized Logs, and automated Alerts/Alarms sent via email/SNS.
    * A detailed end-to-end Workshop deployment guide.
*   **Success Criteria:** 
    * API Response Time remains under 200ms under heavy load.
    * Data integrity is guaranteed: No lost booking messages, and zero double-bookings thanks to SQS FIFO.
    * The system scales precisely (Auto Scaling) when load is simulated.

#### 2.3 Program Alignment
*   **FCAJ / AWS Use-case:** 
    The project accurately simulates the high-load challenges of real-world e-commerce systems, directly applying the core AWS services (Elastic Beanstalk, RDS Multi-AZ, SQS, ElastiCache, CloudFront) taught in the First Cloud AI Journey (FCAJ) program.
*   **Cloud Focus:** 
    The solution deeply focuses on High Availability, Security, and Scalability—the core philosophies of cloud computing, perfectly aligning with cloud infrastructure evaluation criteria.
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

| Category | AWS Service | Selection Rationale & Configuration |
| :--- | :--- | :--- |
| **Compute** | Elastic Beanstalk | Deploys and manages two isolated environments: Backend API and SQS processing Worker. |
| **Compute** | EC2 Instances | Runs Amazon Linux 2023, Node.js 24 runtime, utilizing `t3.micro` instance types. |
| **Compute** | Auto Scaling Group | Scales between a minimum of 2 and a maximum of 4 instances. Scale-out is triggered when average CPU utilization exceeds 70% for 3 minutes (for Backend API) or when SQS message backlog increases (for Worker). |
| **Frontend** | Amazon S3 | Serves the HTML, CSS, and JS assets using S3 Static Website Hosting for cost-effective content delivery. |
| **Database** | RDS PostgreSQL | Runs PostgreSQL version 18.3, instance class `db.t3.small`, 20GB gp3 storage, KMS-encrypted, configured with Multi-AZ for failover. |
| **Database Proxy**| RDS Proxy | Performs connection pooling to handle connections efficiently and protect the database database instance. |
| **Cache** | ElastiCache Redis | 2-node cluster of `cache.t3.micro` instances (1 Primary, 1 Replica) running Redis 7.0.7 for session store and event data caching. |
| **Messaging** | SQS FIFO | Managed queues: `booking-queue.fifo` for processing purchases sequentially, with `checkout-dlq.fifo` (Dead Letter Queue) to capture exceptions. |
| **Email & Alerts** | SNS & SES | **SES** delivers electronic tickets. **SNS** sends operational alerts and infrastructure notifications to administrators. |
| **Security** | IAM, Secrets Manager, KMS | **IAM Roles** configured with Least Privilege principle, no hard-coded access keys. Restricted public access via Private Subnets. **Cognito** for identities; **KMS** for data encryption. |
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
This estimate is based on the [AWS Pricing Calculator](https://calculator.aws/#/estimate?id=55c11e259b0f9e28ba8a407449988fd53d95b250) configured for the Ticket-App.

#### Infrastructure Costs (Staging/Production Environment)

| No. | AWS Service | Configuration Details | Monthly Cost |
| :--- | :--- | :--- | :--- |
| 1 | Elastic Beanstalk (EC2 + ALB) | 4 instances `t3.micro`, 2 Application Load Balancers | ~ $55.15 |
| 2 | RDS PostgreSQL | `db.t3.small` Multi-AZ, 20GB gp3 (Utilization 30%) | ~ $60.52 |
| 3 | ElastiCache Redis | 2-node cluster of `cache.t3.micro` | ~ $24.82 |
| 4 | NAT Gateways | 2 NAT Gateways operating across 2 Availability Zones | ~ $66.15 |
| 5 | S3 & CloudFront | 20GB Standard Storage, CloudFront Free Tier | ~ $0.53 |
| 6 | API Gateway | 1 million requests/month | ~ $1.00 |
| 7 | AWS Cognito | Free tier up to 10,000 Monthly Active Users (MAUs) | $0.00 |
| 8 | CI/CD (CodePipeline & CodeBuild) | 2 pipelines, 1 build/month | ~ $3.50 |
| 9 | CloudWatch & Secrets Manager & SES | Log storage, 1 secret, 5000 emails/month | ~ $5.99 |
| **Total** | **Estimated Monthly Total** | | **~ $217.67** |

*Note:* The cloud infrastructure cost can be trimmed to **under $100.00/month** in development environments by:
*   Removing NAT Gateways and keeping resources in Public Subnets (saves ~$66.15/month), or running only 1 NAT Gateway instead of 2 (saves ~$33.00/month).
*   Switching RDS to Single-AZ instead of Multi-AZ (saves ~$30.00/month).
*   Reducing EC2 instances to 1 per tier and running Redis as a single node when load testing is not active (saves ~$28.00/month).

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
*   **Disaster Recovery:** Utilize RDS Automated Backups and Snapshots to perform Point-in-Time Recovery (PITR), ensuring no loss of critical booking data in the event of a major data or infrastructure failure.
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
    The Frontend, Backend API, and Worker tiers operate independently, allowing targeted auto-scaling based on the distinct load of each tier. The Backend API scales based on CPU utilization (scale-out when average CPU exceeds 70%), while the Worker tier scales based on SQS queue length (Message Backlog). SQS acts as a buffer to handle traffic spikes without overloading the PostgreSQL database.
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
