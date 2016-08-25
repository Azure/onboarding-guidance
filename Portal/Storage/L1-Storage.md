# Storage: Lesson 1. Storage Introduction

# Abstract

During this module, you will learn about Azure Storage, and how to create applications using Azure blobs, tables, queues, and files.

# Learning objectives
Azure Storage is the cloud storage solution for modern applications that rely on durability, availability, and scalability to meet the needs of their customers. After reviewing the [Storage documentation](https://azure.microsoft.com/en-us/documentation/services/storage/) you can learn about the following:
* What Azure Storage is, and how you can take advantage of it in your applications.
* What kinds of data you can store with the Azure Storage services.
* How access to your data in Azure Storage is managed.
* How your Azure Storage data is made durable via redundancy and replication.
* Where to go next to build your first Azure Storage application.

# Prerequisite 
* [Basic Setup Introduction](https://github.com/Azure/onboarding-guidance/blob/master/windows/Module%200/L2-SetupIntro.md)

# Estimated time to complete this module:
Self-guided

# Azure Storage Services
### Azure Storage Introduction
Durable storage for a Virtual Machines Disks is provided by the Azure Storage Service. The Azure Storage Service offers a set of storage services for a range of differing needs. [Blob Storage](https://azure.microsoft.com/en-us/services/storage/blobs/)(Object Storage) for unstructured data, [File Storage](https://azure.microsoft.com/en-us/services/storage/files/) for SMB-based cloud file shares, [Table Storage](https://azure.microsoft.com/en-us/services/storage/tables/) for NoSQL data, [Queue Storage](https://azure.microsoft.com/en-us/services/storage/queues/) to reliably store messages, and [Premium Storage](https://azure.microsoft.com/en-us/services/storage/premium-storage/) for high-performance, low-latency block storage for I/O-intensive workloads running in Azure Virtual Machines. 

### Create and Configure an appropriate Azure Storage Account 
In order to make sure that the customer’s application scales and performs well and is sufficiently protected from disasters, the customer needs to make several decisions with respect to what type of storage account they create and what properties to configure. 

These are high impact decisions that the customer needs to make before getting started, and in order to understand the tradeoffs, the customer should follow [create storage account documentation](https://azure.microsoft.com/en-us/documentation/articles/storage-create-storage-account/#create-a-storage-account). 

Storage accounts for VM disk purposes should be of the “General purpose” type. We also recommend using “Premium” performance type (see below), to gain increased throughput and better latency and consistent performance and latency values for optimal Virtual Machine performance and availability. 

Storage account replication is recommended to be [LRS](https://azure.microsoft.com/en-us/documentation/articles/storage-redundancy/#locally-redundant-storage), instead of “[GRS](https://azure.microsoft.com/en-us/documentation/articles/storage-redundancy/#geo-redundant-storage)” or “[RA-GRS](https://azure.microsoft.com/en-us/documentation/articles/storage-redundancy/#read-access-geo-redundant-storage)”,  as we recommend using VM focused BCDR solutions when working with Disks. Lastly, customers must create the Storage Account in the same region as the Virtual Machines are to be same located in.

### Designing for performance
Customers should refer to [Premium Storage documentation](https://azure.microsoft.com/en-us/documentation/articles/storage-premium-storage/) to understand the features of premium storage, which VM series they should pair it with, and how to architect their storage with respect to their applications performance and scalability needs. This document also includes additional information on what storage account performance and scalability targets are, when user would get throttled and how to get started with further configuration. 
In addition, customers are highly recommended to fully understand how to design for performance using Premium storage in order to ensure what they are building is future proof and will scale according to their specific requirements. 

