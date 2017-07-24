# Fast Track for Azure - SQL Database

This folder is work in progress, please stay tuned! 

# Abstract

During this module you will learn how to create a logical server and an Azure SQL Database using the AdventureWorksLT sample

# Learning Objectves

By the end of this module you will be able to:

* Use the Azure Portal to create a Logical SQL Server and Database in Azure SQL DB

## Pre-Requisites

* There are no pre-requisites to this module

# Estimated time to complete this module:
Self-guided (10 minutes approx)

# Creating a New SQL Database

To create a new database and server you need to:

* Navigate to the portal at [http://ms.portal.azure.com](http://ms.portal.azure.com)
* From the left hand menu select **NEW**
* Select **Database** 
* Select **SQL Database**

![Screenshot](/Images/SQLDB-create-new-db.png)

From the New Database Blade:

* Enter a name for your database *MyTestDatabase*
* Select your subscription
* Create a new Resource Group called *FastTrackDemo*
* Select **AdventureWorksLT** from the Select Source Database drop down menu
* Click on **Server** and then **Create New Server**
* In the new server blade, give the server a unique name - this will be the connection URL
* Enter a username and password for the admin user
* Select a Location for the server *North Europe in this Example*
* Click **Select** at the bottom of the new server blade to accept those values
* Leave the Elastic Pool, Pricing Tier and Collation as default
* Press Create to finish

![Screenshot](/Images/SQLDB-create-new-server.png)

After a few minutes the logical server and sample database will be created.  Once created you will be able to ater settings for the database or open the firewall to allow exteral connection - such as SQL Server Management Studio.





