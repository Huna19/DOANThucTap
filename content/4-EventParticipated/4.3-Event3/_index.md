---
title: "Event 3"
date: 2024-01-01
weight: 3
chapter: false
pre: " <b> 4.3. </b> "
---

# Takeaway from “FCAJ Meetup (06/13/2026)”

### Purpose of the Event

- Provide a realistic, unfiltered picture of what Engineers (DevOps, Data Analytics) actually do at multinational corporations (MNCs), dispelling common student myths.
- Delve into corporate culture, global working standards, and roadmap for sustainable career development, from entry-level to expert.
- Inspire and guide on how to leverage technology communities (AWS) as a launchpad to advance and spread value.

### List of Speakers

- **Mr. Trong H. Truong** (DevOps Engineer @ Endava Vietnam): “What does a DevOps Engineer really do?”
- **Mr. Dat Pham** (Data Analytics Engineer) & **Mr. Cuong Nguyen** (Process Engineer): “Real stories and culture at multinational corporations”
- **Mr. Danh Hoang Hieu Nghi** (AI Engineer): “From First Cloud AI Journey to AWS Partner”
- **Dinh Trung Kien & Nguyen Minh Tho**: “A scalable URL shortening service on AWS”

### Key Highlights

The event featured 4 highly practical sessions:

#### 1) Dinh Trung Kien & Nguyen Minh Tho — A scalable URL shortening service on AWS

- **Purpose**: Solving a classic System Design problem: Building a URL shortening service that is highly scalable, secure, and latency-optimized, rather than a simple, fragile MVP.
- **Risks of a "Simple Flow"**: The basic Frontend → Backend → Database architecture faces numerous issues: Single Point of Failure (SPOF), hard to scale, high read latency, and vulnerability due to lack of edge protection.
- **Real-world AWS Architecture**:
  - **Edge Layer**: Uses Amazon CloudFront combined with AWS WAF to block malicious traffic and distribute static content from Amazon Amplify.
  - **App Layer**: Containerized backend running on Amazon ECS (Fargate), using an Application Load Balancer to route traffic to Private Subnets.
- **Key Generation Service (KGS)**: An excellent move to optimize performance. Instead of generating random keys on-demand, a background service pre-generates short codes and pushes them into a Redis queue (`LPUSH`).
- **Create Flow**: The backend simply pops a pre-generated code from Redis (`RPOP`), associates it with the original URL, and saves it to DynamoDB, eliminating generation latency.
- **Forward Flow / Cache-aside**: The system searches ElastiCache for Redis first. It only queries DynamoDB on a Cache miss, significantly reducing the load on the primary database.

#### 2) Trong H. Truong — What does a DevOps Engineer really do?

- **Myth vs. Reality**: People often think DevOps is just writing CI/CD pipelines, typing Docker/K8s commands, or being the "hero" who fixes servers at midnight. In reality, the scope is much broader: on-call duties, incident handling, access management, cost investigation, and especially Ownership clarification.
- **What to learn first**: Don't chase tools because tools always change. Master the Fundamentals: Linux, Networking, Git, Containers, and a programming language (Python/Golang).
- **Hard-learned lessons**: Copying commands online doesn't mean you understand them. Always ask "Why" before "How". Communication is a core DevOps skill. Use AI to enhance your skills, not to turn off your brain.

#### 3) Dat Pham & Cuong Nguyen — Real stories & MNC Culture

- **Survival Skills**: To work at an MNC, besides hard skills, you must have Critical Thinking, Communication, Problem Solving, and especially "Data Storytelling".
- **5-Level Career Model**: Follower (Executes instructions) → Learner (Proactive learner) → Problem Solver (Resolves issues completely) → System Thinker (Sees the big picture, long-term optimization) → Super Star (Strategic driver and leader).
- **Decoding Corporate Culture**: In tech MNCs, the "No-Blame Post-Mortem" culture is prominent: when a severe error occurs, the team focuses on finding the root cause to fix the system, not blaming individuals.
- **"Đúng Việc" (Right Work) Philosophy**: 3 pillars: Being Human (inner management), Being Professional (serving via expertise), and Being a Citizen (national responsibility, tech legacy).

#### 4) Danh Hoang Hieu Nghi — From First Cloud AI Journey to AWS Partner

- **8-Step Roadmap**: Starting from Student Curiosity → Finding the right environment (First Cloud AI Journey) → Hands-on Labs → Demonstrating capability (Portfolio) → Becoming an AWS Partner → Share Back to the community.
- **Community Power**: Getting a job is just the beginning. Engaging in communities (AWS Student Builder Group, AWS Community Builder) provides an excellent network and practical support: certification vouchers, AWS Credits, and exclusive swags.

### What I Learned

- **Clear awareness**: Tools change constantly; only solid Fundamentals and System Thinking can help engineers go the distance.
- **Stepping stone to MNCs**: Shift mindset from "getting it done" to "getting it done right (to standard)", combined with a "No-Blame" spirit to continuously improve oneself and the system.
- **The importance of giving back**: Technical expertise combined with tech community support creates a powerful launchpad for a career roadmap.
- **System Design Optimization**: Learned Separation of Concerns (separating Read/Write flows), Defense at the Edge (protecting with WAF/CloudFront), and Pre-computation over On-demand (calculating ahead of time rather than in real-time).

### Application to Work

- **Self-study & Practice**: Break the habit of mindlessly copy-pasting code. When using AI to help write scripts or configure infrastructure, force yourself to analyze and fully understand what each line does.
- **Upgrade project mindset**: Apply a System Thinker mindset to internship projects instead of just being a Follower. Don't just make the code run; optimize performance, anticipate risks, and practice clear progress reporting.
- **Personal Branding**: Plan to actively participate in the AWS Student Builder Group to build a high-quality Portfolio and aim towards community building in the future.
- **Apply Cache-aside Pattern**: Use Redis in personal/academic projects to optimize response times for read-heavy APIs.
- **Decouple heavy tasks**: Learn to decouple heavy tasks from the main execution flow using background workers, pre-computing data for smoother processing.

#### Event Photos
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
