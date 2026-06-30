---
title : "Routing & NAT Gateways"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.3.2. </b> "
---

### Routing & NAT Gateways

In this section, we will configure the Internet Gateway, NAT Gateways, and Route Tables to direct network traffic for the Subnets.

---

#### 1. Configure Internet Gateway & NAT Gateways

To allow instances in the Private Subnets to connect to the internet to download packages while keeping them private, we need a NAT Gateway.

1. **Create Internet Gateway (IGW)**:
   * On the navigation bar, select **Internet gateways** -> click **Create internet gateway**.

![Create IGW Button](/images/5-Workshop/5.3-Network-Security/igw_create_btn.png)
![Create IGW](/images/5-Workshop/5.3-Network-Security/igw_create.png)

   * **Name tag**: Enter ```ticket-app-igw``` -> click **Create internet gateway**.
   * After creation, click **Actions** -> Select **Attach to VPC**.

![Attach IGW Button](/images/5-Workshop/5.3-Network-Security/igw_attach_btn.png)

   * Select the ```ticket-app-vpc``` VPC -> click **Attach internet gateway**.

![Attach IGW](/images/5-Workshop/5.3-Network-Security/igw_attach.png)

2. **Allocate Elastic IPs**:
   * Select **Elastic IPs** -> click **Allocate Elastic IP address**.

![Allocate EIP Button](/images/5-Workshop/5.3-Network-Security/eip_allocate_btn.png)
![Allocate EIP](/images/5-Workshop/5.3-Network-Security/eip_allocate.png)

   * Click **Allocate** (Repeat this step 2 times to get 2 static IP addresses for 2 NAT Gateways).

3. **Initialize NAT Gateways**:
   * Select **NAT gateways** -> click **Create NAT gateway**:

![Create NAT Button](/images/5-Workshop/5.3-Network-Security/nat_create_btn.png)

     * **Name**: ```ticket-app-nat-gateway-a```
     * **Subnet**: Select ```ticket-app-subnet-public-a``` (Must be in a Public Subnet).
     * **Elastic IP allocation ID**: Select the first allocated EIP.
     * Click **Create NAT gateway**.

![Create NAT A Top](/images/5-Workshop/5.3-Network-Security/nat_a_create_top.png)
![Create NAT A Bottom](/images/5-Workshop/5.3-Network-Security/nat_a_create_bottom.png)

   * Click **Create NAT gateway** again to create the second one:
     * **Name**: ```ticket-app-nat-gateway-b```
     * **Subnet**: Select ```ticket-app-subnet-public-b```.
     * **Elastic IP allocation ID**: Select the second EIP.
     * Click **Create NAT gateway**.

![Create NAT B Top](/images/5-Workshop/5.3-Network-Security/nat_b_create_top.png)
![Create NAT B Bottom](/images/5-Workshop/5.3-Network-Security/nat_b_create_bottom.png)

---

#### 2. Configure Route Tables

We need to separate the routing paths for Public Subnets (via Internet Gateway) and Private Subnets (via NAT Gateways).

1. **Public Route Table**:
   * Select **Route tables** -> click **Create route table**.

![Create Route Table Button](/images/5-Workshop/5.3-Network-Security/rt_create_btn.png)
![Create Public Route Table](/images/5-Workshop/5.3-Network-Security/rt_public_create.png)

   * **Name**: ```ticket-app-public-rt``` -> Select the ```ticket-app-vpc``` VPC -> click **Create**.
   * Select the newly created ```ticket-app-public-rt``` route table -> Select the **Routes** tab -> click **Edit routes**:

![Edit Public Routes Button](/images/5-Workshop/5.3-Network-Security/rt_public_edit_routes_btn.png)

     * Click **Add route**: Destination ```0.0.0.0/0``` -> Target select **Internet Gateway** -> Select ```ticket-app-igw```.
     * Click **Save changes**.

![Edit Public Routes](/images/5-Workshop/5.3-Network-Security/rt_public_edit_routes.png)

   * Switch to the **Subnet associations** tab -> click **Edit subnet associations**:

![Edit Public Subnets Button](/images/5-Workshop/5.3-Network-Security/rt_public_edit_subnets_btn.png)

     * Check **ticket-app-subnet-public-a** and **ticket-app-subnet-public-b** -> click **Save associations**.

![Edit Public Subnets](/images/5-Workshop/5.3-Network-Security/rt_public_edit_subnets.png)

2. **Private Route Table A**:
   * Click **Create route table** -> Name: ```ticket-app-private-rt-a``` -> Select VPC -> click **Create**.
   * **Routes** tab -> click **Edit routes** -> Add route: Destination ```0.0.0.0/0``` -> Target select **NAT Gateway** -> Select ```ticket-app-nat-gateway-a``` -> Save.

![Edit Private A Routes Button](/images/5-Workshop/5.3-Network-Security/rt_private_a_edit_routes_btn.png)
![Edit Private A Routes](/images/5-Workshop/5.3-Network-Security/rt_private_a_edit_routes.png)

   * **Subnet associations** tab -> Edit -> Select **ticket-app-subnet-private-a** -> Save.

![Edit Private A Subnets Button](/images/5-Workshop/5.3-Network-Security/rt_private_a_edit_subnets_btn.png)
![Edit Private A Subnets](/images/5-Workshop/5.3-Network-Security/rt_private_a_edit_subnets.png)

3. **Private Route Table B**:
   * Do the same, create route table ```ticket-app-private-rt-b``` -> route ```0.0.0.0/0``` to **NAT Gateway B** -> Associate with **ticket-app-subnet-private-b**.
