# POC Scenario Voting Application: Working with Service Fabric Services  
# Abstract  
The goal of this poc is to make you familiar with an end to end development flow for Service Fabric applications. You will practice creating a new Service Fabric application on your development machine, working with stateless services, deploying, updating and monitoring an application deployment. Throughout the exercise, you will get accustomed with Visual Studio’s Service Fabric tooling, Service Fabric Explorer and learn how to effectively use both.

In this scenario, you will build a generic voting service using Service Fabric reliable services. The service listens to an endpoint accessible from a Web browser. You’ll enter vote item strings (such as favorite sodas or cars) using a single page application (SPA). Each time the same vote item is voted on, a counter is incremented; this represents the number of times the item has been voted for. Each HTML response contains all the votes items and the number of times that vote item was voted for.

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

## Create a Service Fabric Cluster in the portal

 * Follow these steps to create a Service Fabric Cluster in Azure
 * ARM Templates to Deploy Service Fabric Clusters


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
 * [Troubleshoot] (https://azure.microsoft.com/en-us/documentation/articles/service-fabric-troubleshoot-local-cluster-setup/) an environment
 * [Elastic Search](https://azure.microsoft.com/en-us/documentation/articles/service-fabric-diagnostic-how-to-use-elasticsearch/)
 * [Partitioning Concepts](https://azure.microsoft.com/en-us/documentation/articles/service-fabric-concepts-partitioning/)
