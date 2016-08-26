# Compute Introduction

# Abstract

During this module, you will learn to provision, migrate, and manage your Windows virtual machines.

# Learning objectives
After completing the exercises in this module, you will be able to:
* Work with resource groups.
* Work with images, search datacenter capabilities, and select desired images.
* Setup Resource Groups, Storage Account, and Networking.
* Prepare VM images for capture by generalizing.
* Deploy a new VM from captured images.
* Get information regarding Storage Accounts and Virtual Networks.

# Prerequisite 
* Completion of [Module on Storage](https://github.com/Azure/onboarding-guidance/tree/master/windows/Module%20I)

# Estimated time to complete this module:
Self-guided

# What is a Virtual Machine?
Virtual Machines gives you lots of control over the virtual machines your small or multi-tier applications are running on – as if the VMs were another rack in your datacenter. This learning path will help you understand how to create and manage VMs using the Azure portal, PowerShell, the Azure CLI, and Resource Manager templates.
Azure Virtual Machines is one of several types of on-demand, scalable computing resources that Azure offers. Typically, you'll choose a virtual machine if you need more control over the computing environment than the other choices offer.

# Why do I want to use Virtual Machines?
An Azure virtual machine gives you the flexibility of virtualization without having to buy and maintain the physical hardware that runs the virtual machine. However, you still need to maintain the virtual machine -- configuring, patching, and maintaining the software that runs on the virtual machine.

# Virtual Machine Series and Sizes
When deploying a Virtual Machine in Azure there is a need to consider what resources are going to be needed for that VM. Azure provides a number of choices that the customer needs to consider before creating their VMs. All virtual machines created in Azure are of a predefined size, these sizes are grouped by series where the series defines a set of characteristics that all VMs of that series have (for example processor type).  Customers should read and understand [this](https://azure.microsoft.com/en-gb/documentation/articles/virtual-machines-windows-sizes/) article that explains the series and sizes available

# Management of Resources
All Azure resources such as Virtual Machines are created within the scope of a Resource Group, Resource Groups should be thought of as management containers for resources, you decide how you want to allocate resources to resource groups based on the requirements of your organization. One important aspect to consider is management scope, for example you may want one group to be responsible for network assets and a different group to be responsible for management of Virtual Machines, alternatively you may want all the resources for an entire application to be managed by a single group, Resource Groups afford you this level of flexibility and control.  You can read more about the considerations for Resource Group creation at [Click here](https://azure.microsoft.com/en-us/documentation/articles/resource-group-overview/#resource-groups)

In addition to Resource Groups, Azure also allows polices to be enforced over resources created, for example using policies it is possible to limit the Azure regions in which resources can be created, you can learn more about the capabilities and considerations of policy based management at [Click here](https://azure.microsoft.com/en-us/documentation/articles/resource-manager-policy/) 
