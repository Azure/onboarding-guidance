# Module: Storage Introduction

# Abstract

During this module, you will learn about Azure Storage, and how to create applications using Azure blobs, tables, queues, and files.

# Learning objectives
After completing the exercises in this module, you will be able to:
* Create a storage account using PowerShell
* Create a Resource Group
* Verify creation of Storage Account
* List all of the blobs in all of your containers
* Delete Storage Account

# Prerequisite 
* [Basic Setup Introduction](https://github.com/Azure/onboarding-guidance/blob/master/windows/Module%200/L2-SetupIntro.md)

# Estimated time to complete this module:
30 minutes

# What is Azure Storage?
Azure Storage is the cloud storage solution for modern applications that rely on durability, availability, and scalability to meet the needs of their customers. After reviewing the [Storage documentation](https://azure.microsoft.com/en-us/documentation/services/storage/) you can learn about the following:
* What Azure Storage is, and how you can take advantage of it in your applications.
* What kinds of data you can store with the Azure Storage services.
* How access to your data in Azure Storage is managed.
* How your Azure Storage data is made durable via redundancy and replication.
* Where to go next to build your first Azure Storage application.

# See the following resources to learn more
* [Click here for Storage documentation](https://azure.microsoft.com/en-us/documentation/services/storage/)
* [SLA for Storage](https://azure.microsoft.com/en-us/support/legal/sla/storage/v1_1/)
* [Storage Team Blog](https://blogs.msdn.microsoft.com/windowsazurestorage/)
* [Azure Storage Scalability and Performance Targets](https://azure.microsoft.com/en-us/documentation/articles/storage-scalability-targets/)
* [Azure Storage replication](https://azure.microsoft.com/en-us/documentation/articles/storage-redundancy/)
* [Azure Storage Client Tools](https://azure.microsoft.com/en-us/documentation/articles/storage-explorers/)
* [Moving data to and from Azure Storage](https://azure.microsoft.com/en-us/documentation/articles/storage-moving-data/)

# Ask Anusha about the following
## Azure Storage

### Types of Azure Storage
  * [Standard Storage](https://azure.microsoft.com/en-us/services/storage/)
  * [Premium Storage](https://azure.microsoft.com/en-us/services/storage/premium-storage/)
    - [Azure Premium Storage, now generally available](https://azure.microsoft.com/en-us/blog/azure-premium-storage-now-generally-available-2/)
    - [New Premium Storage-Backed Virtual Machines](https://azure.microsoft.com/en-us/blog/new-premium-storage-backed-virtual-machines/)
    - [Introducing Premium Storage: High-Performance Storage for Azure Virtual Machine Workloads](https://azure.microsoft.com/en-us/blog/introducing-premium-storage-high-performance-storage-for-azure-virtual-machine-workloads/)
    - [Premium Storage: High-Performance Storage for Azure Virtual Machine Workloads](https://azure.microsoft.com/en-us/documentation/articles/storage-premium-storage/)
    - [Azure Premium Storage: Design for High Performance](https://azure.microsoft.com/en-us/documentation/articles/storage-premium-storage-performance/)
### Types of services in Azure Storage
  * Container ([Blob Storage](https://azure.microsoft.com/en-us/services/storage/blobs/))
    - Block Blobs
    - Append blobs
    - Page blobs (disks).
  * [Table Storage](https://azure.microsoft.com/en-us/services/storage/tables/) (Entities)
  * [Queue Storage](https://azure.microsoft.com/en-us/services/storage/queues/) (Messages)
  * Share (Directories/ [File storage](https://azure.microsoft.com/en-us/services/storage/files/))
