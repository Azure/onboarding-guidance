# Module: Networking Introduction

# Abstract

During this module, you will learn how Microsoft Azure networking provides the infrastructure necessary to securely connect Virtual Machines (VMs) to one another, and be the bridge between the cloud and on-premises datacenter.

# Learning objectives
After completing the exercises in this module, you will be able to:
* Create a virtual network by using PowerShell.
* Learn how to assign names and subnets to VNETs.
* Create a Point to Site Connection (On-premise to Azure).
* Create Site to site Connection (On-premises to Azure).
* Connect two Virtual Network (Azure to Azure).

# Prerequisite 
* Completion of [Module on Compute](https://github.com/Azure/onboarding-guidance/blob/master/windows/Module%20II/L1-ComputeIntro.md)

# Estimated time to complete this module:
4-6 hours

# What is a Virtual Network?
An Azure virtual network (VNet) is a representation of your own network in the cloud. It is a logical isolation of the Azure cloud dedicated to your subscription. You can fully control the IP address blocks, DNS settings, security policies, and route tables within this network. You can also further segment your VNet into subnets and launch Azure IaaS virtual machines (VMs) and/or Cloud services (PaaS role instances). Additionally, you can connect the virtual network to your on-premises network using one of the connectivity options available in Azure. In essence, you can expand your network to Azure, with complete control on IP address blocks with the benefit of enterprise scale Azure provides.

# Why do I want to use a Virtual Network?
**Isolation.** VNets are completely isolated from one another. That allows you to create disjoint networks for development, testing, and production that use the same CIDR address blocks.

**Access to the public Internet.** All IaaS VMs and PaaS role instances in a VNet can access the public Internet by default. You can control access by using Network Security Groups (NSGs).

**Access to VMs within the VNet.** PaaS role instances and IaaS VMs can be launched in the same virtual network and they can connect to each other using private IP addresses even if they are in different subnets without the need to configure a gateway or use public IP addresses.

**Name resolution.** Azure provides internal name resolution for IaaS VMs and PaaS role instances deployed in your VNet. You can also deploy your own DNS servers and configure the VNet to use them.

**Security.** Traffic entering and exiting the virtual machines and PaaS role instances in a VNet can be controlled using Network Security groups.

**Connectivity.** VNets can be connected to each other, and even to your on-premises datacenter, by using a site-to-site VPN connection, or ExpressRoute connection.

# Module III (Core Setup - Virtual Network)

* [Lesson 1. Azure Networking Introduction](https://github.com/Azure/onboarding-guidance/blob/master/windows/Module%20III/L1-NetworkIntro.md)
* [Lesson 2. Create a Virtual Network](https://github.com/Azure/onboarding-guidance/blob/master/windows/Module%20III/L2-CreateVirtualNetwork.md)
* [Lesson 3. Create Point to site Connection (On-premises to Azure)](https://github.com/Azure/onboarding-guidance/blob/master/windows/Module%20III/L3-Point2Site.md)
* [Lesson 4. Create Site to site Connection (On-premises to Azure)](https://github.com/Azure/onboarding-guidance/blob/master/windows/Module%20III/L4-Site2SiteAuzreonPremise.md)
* [Lesson 5. Connect two Virtual Network (Azure to Azure)](https://github.com/Azure/onboarding-guidance/blob/master/windows/Module%20III/L5-Site2Site2Vnets.md)

# See the following resources to learn more
* [Virtual Network Overview](https://azure.microsoft.com/en-us/documentation/services/virtual-network/)
* [SLA for VPN Gateway](https://azure.microsoft.com/en-us/support/legal/sla/vpn-gateway/v1_0/)
