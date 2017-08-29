# POC Scenario Voting Application: Working with Service Fabric Services  
# Abstract  
The goal of this poc is to make you familiar with an end to end development flow for Service Fabric applications. You will practice creating a new Service Fabric application on your development machine, working with stateless services, deploying, updating and monitoring an application deployment. Throughout the exercise, you will get accustomed with Visual Studio’s Service Fabric tooling, Service Fabric Explorer and learn how to effectively use both.

**The voting application consists of two services**:
* Web front-end service (VotingWeb)- An ASP.NET Core web front-end service, which serves the web page and exposes web APIs to communicate with the backend service.
* Back-end service (VotingData)- An ASP.NET Core web service, which exposes an API to store the vote results in a reliable dictionary persisted on disk.
 
**When you vote in the application the following events occur**:
1. A JavaScript sends the vote request to the web API in the web front-end service as an HTTP PUT request.
2. The web front-end service uses a proxy to locate and forward an HTTP PUT request to the back-end service.
3. The back-end service takes the incoming request, and stores the updated result in a reliable dictionary, which gets replicated to multiple nodes within the cluster and persisted on disk. All the application's data is stored in the cluster, so no database is needed.

# Learning objectives
After completing the exercises in this module, you will be able to:
* Set up and manage Service Fabric clusters on your development machine
* Set up Service Fabric Clusters in Azure
* Understand the concepts of Service Fabric applications, services, stateless services, application lifecycle management, upgrades, diagnostics and health
* Use Visual Studio and Service Fabric Explorer to efficiently develop Service Fabric applications

## Pre-Requisites
* To complete this PoC, you will need:
    * Visual Studio 2017
    * You need to have an Azure subscription
    * Download Azure SDK Tools 2.9 or above from the Web platform installer and install the SDK
    * Download the Service Fabric developer SDK: http://aka.ms/ServiceFabricSDK
     * You will need Service Fabric Local Cluster Manager to manage your local dev cluster
       * Open following folder:
         C:\Program Files\Microsoft SDKs\Service Fabric\Tools\ServiceFabricLocalClusterManage And run ServiceFabricLocalClusterManager.exe
    * Download the starter application from [GitHub](https://github.com/Azure-Samples/service-fabric-dotnet-quickstart)

## Walk through the voting sample application
 * [Create a .NET Service Fabric application in Azure](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-quickstart-dotnet)
 * [Steb-by-Step](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-tutorial-create-dotnet-app), build the .NET Voting application

## Create a Service Fabric Cluster

 * Follow [these](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-cluster-creation-via-portal) steps to create a Secure Service Fabric Cluster in Azure
 * [Create a Secure Service Fabric Cluster](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-tutorial-create-cluster-azure-ps) using PowerShell
 * [ARM Template](https://github.com/Azure/azure-quickstart-templates/tree/master/service-fabric-secure-cluster-5-node-1-nodetype) to Deploy Service Fabric Clusters 
 * [GitHub Quickstart Templates](https://github.com/Azure/azure-quickstart-templates)
 * [Azure Quickstart Templates](https://azure.microsoft.com/en-us/resources/templates/)

## Additional Resources
* Service Farbic Getting [Started](http://aka.ms/ServiceFabric)
* Download the samples from [GitHub](http://github.com/Azure/ServiceFabric-Samples)
* Service Fabric [Learning Path](https://azure.microsoft.com/en-us/documentation/learning-paths/service-fabric/)
* [Ignite Session](https://myignite.microsoft.com/videos/3168)
* Theory: [Microservices defined by Martin Fowler and James Lewis](http://martinfowler.com/microservices/)
* Service Fabric [Service Communications](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-connect-and-communicate-with-services)
* Create a [Windows Cluster](https://azure.microsoft.com/en-us/documentation/articles/service-fabric-cluster-creation-for-windows-server/)
* [On-Premise](https://azure.microsoft.com/en-us/documentation/articles/service-fabric-cluster-creation-for-windows-server/#plan-and-prepare-your-cluster-deployment)
* Update [Fabric Version](https://azure.microsoft.com/en-us/documentation/articles/service-fabric-cluster-upgrade/#controlling-the-fabric-version-that-runs-on-your-cluster)
 * Upgrade [Windows Servers](https://azure.microsoft.com/en-us/documentation/articles/service-fabric-cluster-upgrade-windows-server/)
 * [Service Fabric on Linux](https://azure.microsoft.com/en-us/documentation/articles/service-fabric-linux-overview/)
 * Connect to a [Secure Cluster](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-connect-to-secure-cluster)
 * [Upgrade and clean up Service Fabric Development environment](https://azure.microsoft.com/en-us/documentation/articles/service-fabric-update-your-development-environment/)
 * [Troubleshoot](https://azure.microsoft.com/en-us/documentation/articles/service-fabric-troubleshoot-local-cluster-setup/) an environment
 * [Elastic Search](https://azure.microsoft.com/en-us/documentation/articles/service-fabric-diagnostic-how-to-use-elasticsearch/)
 * [Partitioning Concepts](https://azure.microsoft.com/en-us/documentation/articles/service-fabric-concepts-partitioning/)
