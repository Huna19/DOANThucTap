---
title: "Event 2"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 4.2. </b> "
---

# Takeaway from “AWS Community Day (05/23/2026)”

### Purpose of the Event

- Update on the latest technology trends on AWS, especially deep dives into AI/ML, Multi-Agent architecture, and infrastructure optimization.
- Create a networking space to learn from experts from various enterprises.
- Discuss practical case studies (e.g., startup credit risk assessment, building a Second Brain, CloudFront architecture).

### List of Speakers

- **Anh Tinh**: Build second brain
- **Hai Anh**: Friendly AI Assistant with Amazon Q
- **Thinh**: From Edge To Origin: CloudFront as Your Foundation
- **Team VIB**: 36 hrs with LotusHacks – Building UTMorpho from Idea to Reality
- **Dao Duc**: Deep dive talk: How LLM actually works
- **Cat Vy**: Enterprise-Grade Multi-Agent System: The Case of Startup Credit Scoring

### Key Highlights

The event featured 6 profound technical sessions:

#### 1) Context Engineering & Building a Second Brain (Anh Tinh)

- **Why AI performs poorly**: Inaccurate or generic answers are rarely due to poor AI models, but rather input data lacking context.
- **The "Internet Puller" Mistake**: Users tend to stuff entire documents into chat. Garbage input not only reduces accuracy but also wastes token costs.
- **Context Standardization Framework**: For AI to act as a "Second Brain", input must be designed like delegating to a human, including 4 elements: Goal, Relevant info, Constraints, and Success criteria.
- **Memory System Architecture**: A complete AI system flows as: Store → Retrieve → Generate → Learn.

#### 2) Enterprise Virtual Assistant & Agentic AI (Hai Anh)

- **Enterprise Data Challenges**: Staff repeatedly perform time-consuming manual tasks and search for scattered information.
- **The Power of Amazon Quick Suite**: Agentic AI unifies the user experience, accelerating the process from Insight to Action.
- **Integration Capabilities**: Directly connects to 40+ Data connectors, internal databases, web search, and thousands of 3rd-party actions.
- **Responsible AI Controls**: Ensures data safety via Governance, Access controls, and Guardrails to comply with legal regulations.

#### 3) Edge Infrastructure Optimization with Amazon CloudFront (Thinh)

- **The "Bill Shock" Problem**: With Pay-as-you-go pricing, startups face financial risks during viral traffic spikes or cyber attacks, causing bills to shoot up to $100,000.
- **Fixed-Price Solution**: AWS offers fixed-price packages including CDN, WAF, Anti-DDoS, Route 53, and S3, helping businesses easily control finances.
- **Data Compression at the Edge**: CloudFront automatically compresses HTTP content, reducing download size by 82% and latency by 81%. Integrating HTTP/3 (QUIC/UDP) enables parallel multiplexing of static files.
- **Origin Cloaking**: Uses Origin Access Control (OAC) or Custom Headers to completely hide the origin server from the public internet.

#### 4) 36 Hours at LotusHacks (Team VIB)

- **Building UTMorpho**: An application rapidly designed and deployed in 36 hours, powered by Claude Sonnet 4 on the US-East-1 region.
- **Biggest Technical Barrier**: The team faced "AI Overgeneration" and constantly hit Token Limits as deadlines approached.
- **Lessons Learned**: "Real Frustration Creates Real Ideas". In a Hackathon, Team Sync and endurance matter more than the quantity of ideas.

#### 5) The Nature of LLM Nondeterminism (Dao Duc)

- **The Temperature = 0 Myth**: Theoretically, T=0 makes the LLM pick the highest probability token for 100% identical output. Reality shows accuracy fluctuates by 15%, and the gap between best/worst runs can reach 70% for the same prompt.
- **Root Cause**: Floating-point math processed in parallel on GPUs is not associative: (a+b)+c != a+(b+c). Furthermore, Inference batching changes calculations for specific requests.
- **Mitigation Strategy**: Engineers must design systems tolerant of errors, use Majority voting, and optionally set Temperature to 0.1 to avoid infinite vocabulary loops.

#### 6) Enterprise-Grade Multi-Agent Architecture (Cat Vy)

- **Limitations of Traditional Banking & Single Agents**: Startups are rejected due to lacking financial reports/collateral. Using a single AI Agent causes Context limits, expertise dilution, lacks Checks & Balances, and creates a Single Point of Failure.
- **Multi-Agent Solution (Virtual Credit Committee)**: Building a virtual committee with specialized agents: Manager, Financial Analyst, Market Analyst, Team Evaluator, Risk Assessor, and Compliance.
- **Operational ROI**: Reduced approval time from 2-3 weeks to 2-4 hours. Decision costs dropped from ~100M VND to under 5M VND, doubling the approval rate to 35-45%.
- **Deployment Infrastructure**: Dockerized, pushed to Amazon ECR, integrated into Bedrock AgentCore Runtime, connected via AWS Lambda, and exposed via API Gateway.

### What I Learned

- Understood the shift from using a single AI model to a Multi-Agent Paradigm for solving complex, highly branched enterprise problems.
- Gained a clearer perspective on the importance of Security & Compliance (Guardrails) when deploying AI to a Production environment.
- Grasped how to optimize data flow latency via CloudFront and integrate Amazon Q into daily workflows.
- Understood the nondeterministic nature of LLMs and how to design fault-tolerant systems when working with AI.

### Application to Work

- Explore integrating **Amazon Q** into debugging and reading AWS documentation to save time.
- Network Design: Prioritize deploying **CloudFront** at the edge combined with WAF and OAC to increase page load speed, hide origin servers, and ensure security.
- When designing future AI features, aim to split the logic for specialized "Agents" to process, rather than cramming everything into a single prompt.
- Build a prompt writing framework applying the 4 elements: Goal, Relevant Info, Constraints, and Success Criteria.

### Event Experience

The event delivered extremely high technical value. While Event 1 leaned towards career orientation and basic prompt optimization, Event 2 dove straight into system architecture and how large enterprises deploy AI securely and cost-effectively. I was particularly impressed by Cat Vy's Multi-Agent case study, which painted a clear picture of Enterprise-grade AI with convincing ROI figures. Additionally, the "Bill Shock" problem and CloudFront solution provided a highly practical lesson for upcoming projects.

#### Event Photos
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
