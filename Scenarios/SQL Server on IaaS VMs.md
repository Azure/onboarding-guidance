# POC Scenario: Deploying SQL Server on Azure IaaS VMs

# Introduction
SQL Server installed and hosted in the cloud on Windows Server Virtual Machines (VMs) running on Azure, also known as an infrastructure as a service (IaaS). SQL Server on Azure virtual machines is optimized for migrating existing SQL Server applications. All the versions and editions of SQL Server are available. It offers 100% compatibility with SQL Server, allowing you to host as many databases as needed and executing cross-database transactions. It offers full control on SQL Server and Windows.

# Use Case Scenarios
There are many reasons that you might choose to host your data in Azure. If your application is moving to Azure, it improves performance to also move the data. But there are other benefits. You automatically have access to multiple data centers for a global presence and disaster recovery. The data is also highly secured and durable.

SQL Server running on Azure VMs is one option for storing your relational data in Azure. For example, you might want to configure the Azure VM as similarly as possible to an on-premises SQL Server machine. Or you might want to run additional applications and services on the same database server. 

#### Host enterprise SQL Server apps in the cloud
Reduce your capital investments and optimize operational expenses by running your on-premises Microsoft SQL Server applications in Azure. Azure gives you a wide range of SQL Server editions, including SQL Enterprise. Customers with Software assurance can choose to pay the SQL Server licensing based on usage or easily leverage their existing SQL Server licenses using our BYOL (Bring-Your-Own-License) images

#### Develop and test SQL Server apps easily and cost effectively
Azure gives you a fast, cost-effective way to develop and test SQL Server applications. Spin up a new development environment in minutes, paying only for what you use. SQL Server Developer images, including SQL Server 2016, provide all the SQL Server features with a free license for development and testing.

#### Protect SQL Server databases in the cloud
Azure Storage offers flexible, reliable, and limitless off-site backup storage for your SQL Server applications, without the hassles of traditional tape archives. Enable full backups with point-in-time restore directly through SQL Server Management Studio. Back up on-premises SQL Server databases and instances running in an Azure virtual machine—and restore backups to either your datacenter or an Azure virtual machine.

#### Improve business continuity and global BI reporting
In the event of a disaster, you can improve business continuity by placing your SQL Server AlwaysOn Availability Group replicas in virtual machines. SQL Server 2014 gives you up to eight readable replicas, which you can deploy to a fast-growing list of Azure regions around the world. You can also use AlwaysOn to set up fast failover for database applications running in Azure. Strategic placement of your SQL Server replicas not only improves business continuity and disaster recovery, but lets you offload business intelligence reporting to the closest Azure region

#### For additional information refer to the following resources
[SQL Server on Azure virtual machines](https://azure.microsoft.com/en-us/services/virtual-machines/sql-server/)  provides an overview of the best scenarios for using SQL Server on Azure VMs.

Choose a cloud SQL Server option: [Azure SQL (PaaS) Database or SQL Server on Azure VMs (IaaS)](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-paas-vs-sql-server-iaas) provides a detailed comparison between SQL Database and SQL Server running on a VM.


# Prerequisite 
* Understanding of Azure IaaS concepts & Azure Subscription to deploy SQL server.

# Estimated time to complete this module:
Self-guided.

# Performance best practices for SQL Server in Azure Virtual Machines

This topic provides best practices for optimizing SQL Server performance in Microsoft Azure Virtual Machine. While running SQL Server in Azure Virtual Machines, we recommend that you continue using the same database performance tuning options that are applicable to SQL Server in on-premises server environment. However, the performance of a relational database in a public cloud depends on many factors such as the size of a virtual machine, and the configuration of the data disks. 

When creating SQL Server images, [consider provisioning your VMs in the Azure portal](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sql/virtual-machines-windows-portal-sql-server-provision). SQL Server VMs provisioned in the Portal with Resource Manager implement all these best practices, including the storage configuration. 

If your workload is less demanding, you might not require every optimization listed in the following performance best practices document. Consider your performance needs and workload patterns as you evaluate these recommendations.

For more information on *how* to make optimizations, please review [Performance best practices for SQL Server in Azure Virtual Machines](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sql/virtual-machines-windows-sql-performance)

# Setup & Configuraiton
When it comes to deploying SQL Server on IaaS VMs, it can be deployed in few different ways. It can be deployed through Azure Portal, PowerShell or using Resource Manager Template. Few widely used options covered below.

#### Provision a single SQL Server virtual machine using Azure Portal

This end-to-end tutorial shows you how to use the Azure Portal to provision a virtual machine running SQL Server. 
The Azure virtual machine gallery includes several images that contain Microsoft SQL Server. With a few clicks, you can select one of the SQL VM images from the gallery and provision it in your Azure environment.

For a step-by-step tutorial please see [Provision a Single SQL Server VM](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sql/virtual-machines-windows-portal-sql-server-provision) 


#### Provision a single SQL Server virtual machine using Azure PowerShell 

This tutorial shows you how to create a single Azure virtual machine using the Azure Resource Manager deployment model using Azure PowerShell cmdlets. In this tutorial, we will create a single virtual machine using a single disk drive from an image in the SQL Gallery. 

For a step-by-step tutorial please see [Provision a Single SQL Server VM using PowerShell](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sql/virtual-machines-windows-ps-sql-create) 


#### Provision SQL Server Always On availability groups on Azure virtual machines using Azure Portal

This tutorial introduces SQL Server availability groups setup on Azure Virtual Machines using Portal. Always On availability groups on Azure Virtual Machines are similar to Always On availability groups on premises. For more information, see Always On [Availability Groups (SQL Server)](https://msdn.microsoft.com/library/hh510230.aspx). 

The figure below is a graphical representation of the solution.
![Screenshot](/Images/AOAG-AzureVM-Portal.png)

For a step-by-step tutorial please see on how to [Manually create an availability group in Azure portal](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sql/virtual-machines-windows-portal-sql-availability-group-overview#manually-create-an-availability-group-in-azure-portal)


#### Provision SQL Server Always On availability groups on Azure virtual machines using Template

This tutorial shows you how to create a SQL Server availability group with Azure Resource Manager virtual machines. The tutorial uses Azure blades to configure a template. You will review the default settings, type required settings, and update the blades in the portal as you walk through this tutorial. 

At the end of the tutorial, your SQL Server availability group solution in Azure will consist of the following elements: 

* A virtual network containing multiple subnets, including a front-end and a back-end subnet

* Two domain controller with an Active Directory (AD) domain

* Two SQL Server VMs deployed to the back-end subnet and joined to the AD domain

* A 3-node WSFC cluster with the Node Majority quorum model

* An availability group with two synchronous-commit replicas of an availability database

The figure below is a graphical representation of the solution.
![Screenshot](/Images/AOAG-AzureVM-Template.png)

For a step-by-step tutorial please see on how to [Configure Always On availability group in Azure VM automatically - Resource Manager](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sql/virtual-machines-windows-portal-sql-alwayson-availability-groups)

# Migrate a SQL Server database to SQL Server in an Azure VM
There are a number of methods for migrating an on-premises SQL Server user database to SQL Server in an Azure VM. 

#### What are the primary migration methods?

The primary migration methods are:

* Perform on-premises backup using compression and manually copy the backup file into the Azure virtual machine

* Perform a backup to URL and restore into the Azure virtual machine from the URL

* Detach and then copy the data and log files to Azure blob storage and then attach to SQL Server in Azure VM from URL

* Convert on-premises physical machine to Hyper-V VHD, upload to Azure Blob storage, and then deploy as new VM using uploaded VHD

* Ship hard drive using Windows Import/Export Service

* If you have an AlwaysOn deployment on-premises, use the [Add Azure Replica Wizard](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sqlclassic/virtual-machines-windows-classic-sql-onprem-availability) to create a replica in Azure and then failover, pointing users to the Azure database instance

* Use SQL Server [transactional replication](https://msdn.microsoft.com/library/ms151176.aspx) to configure the Azure SQL Server instance as a subscriber and then disable replication, pointing users to the Azure database instance

For more information on choosing the right migration method see [Migrate a SQL Server database to SQL Server in an Azure VM](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sql/virtual-machines-windows-migrate-sql)

# Security Considerations for SQL Server in Azure Virtual Machines

This topic includes overall security guidelines that help establish secure access to SQL Server instances in an Azure VM. However, in order to ensure better protection to your SQL Server database instances in Azure, we recommend that you implement the traditional on-premises security practices in addition to the security best practices for Azure.

For more information about the SQL Server security practices, see [SQL Server 2008 R2 Security Best Practices - Operational and Administrative Tasks](http://download.microsoft.com/download/1/2/A/12ABE102-4427-4335-B989-5DA579A4D29D/SQL_Server_2008_R2_Security_Best_Practice_Whitepaper.docx)

Azure complies with several industry regulations and standards that can enable you to build a compliant solution with SQL Server running in a Virtual Machine. For information about regulatory compliance with Azure, see [Azure Trust Center](https://azure.microsoft.com/en-us/support/trust-center/).

For more information see [Security Considerations for SQL Server in Azure Virtual Machines](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sql/virtual-machines-windows-sql-security#considerations-for-managing-accounts).

# Additional resources

#### Application Patterns and Development Strategies for SQL Server in Azure Virtual Machines

Determining which application pattern or patterns to use for your SQL-Server-based applications in Azure environment is an important design decision and it requires a solid understanding of how SQL Server and each infrastructure component of Azure work together. With SQL Server in Azure Infrastructure Services, you can easily migrate, maintain, and monitor your existing SQL Server applications built-on Windows Server to virtual machines in Azure. 

The goal of this article is to provide solution architects and developers a foundation for good application architecture and design, which they can follow when migrating existing applications to Azure as well as developing new applications in Azure. 

For each application pattern, you will find an on-premises scenario, its respective cloud-enabled solution, and the related technical recommendations. In addition, the article discusses Azure-specific development strategies so that you can design your applications correctly. Due to the many possible application patterns, it’s recommended that architects and developers should choose the most appropriate pattern for their applications and users.

For more information see [Application Patterns and Development Strategies for SQL Server in Azure VM](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sql/virtual-machines-windows-sql-server-app-patterns-dev-strategies)