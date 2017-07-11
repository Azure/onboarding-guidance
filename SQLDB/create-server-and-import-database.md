# Fast Track for Azure - SQL Database

This folder is work in progress, please stay tuned! 

# Abstract

During this module you will learn the process for exporting a database from a physical or virtual SQL Server and you will learn how to import a database into Azure SQL Databse using a reference database extract (bacpac)

# Learning Objectves

By the end of this module you will be able to:

* Export a database from a physical or virtual SQL Server
* Create an Azure SQL DB logical Server
* Import a database into Azure SLQ DB from a backpac file

## Pre-Requisites

* To complete this module you will need to:
    * Download the reference dataabase [WorldWide-Importers-Standard.bacpac](https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Standard.bacpac)
    * Create a Storage account and a container in blob storage
    * Upload the reference database to the container in blob storage

# Estimated time to complete this module:
Self-guided (10 minutes approx)

# Exporting a Database (overview)

Exporting a database from a physical server or virtual machine makes use of the built in functionallity of SQL Server.  Data exports to Azure use the BACPAC file format, which is a specific type of zip file that contains metadata for the structure of teh databse as well as teh actual data its self.  To export a database to a bacpac file you need to:

* Right click on the database in SQL Server Management Studio
* Select "Tasks" from the context menu
* Select "Export data tier Application" from the next context menu

    ![Screenshot](/Images/SQLDB-exportdb.png)

Follow the export wizard to export the database either locally or directly to Azure Blob Storage.  For larger databases it is recommended that you export teh database locally adn then upload using Azcopy.  

For very large databases you should consider using the Azure import/export service to transfer the data. [https://azure.microsoft.com/en-us/pricing/details/storage-import-export/](https://azure.microsoft.com/en-us/pricing/details/storage-import-export/)
    
# Creating a Logical SQL Server

Before you can import a database you need to have a running logical Azure SQL Server.  The SQL Server is the administration point for the databases and allows you to import a bacpac file into it.  

This walkthough assumes you do not currently have a logical SQL Server but you can easily use an existing one if you already have one in your subscription.

To provision a SQL Server you need to:

* Go to the Azure portal [http://ms.portal.azure.com](http://ms.portal.azure.com)
* Select "new" from the left hand menu
* Enter SQL Server in the search box and press enter
* Select "SQL Server (logical server) from the result

    ![Screenshot](/Images/SQLDB-New-SQLDB-Server.PNG)

Fill out the detail in the SQL Server blade and press create to provision the logical server

# Importing a Database

Now that you have a running logical SQL Server you can start the import database process. 

* Click on the SQL Server to open the Server blade
* Press "Import Database" from the menu at the top

    ![Screenshot](/Images/SQLDB-Import-SQLDB.PNG)

On the SQL Database blade you need to:

* Select your subscription from the dropdown menu
* Browse to the .bacpac file that you uploaded into blob storage
* Rename the database to "WorldImporters"
* Change the Authentication to SQL Server
* Enter the useranme and password that you used to provision the logical server with
* Press OK to start the import

    ![Screenshot](/Images/SQLDB-Import-DB-Options.PNG)

# Monitoring the Import Progress

Once the import is underway, you can monitor the progress by clicking on the Import/Export History tile located on the logical SQL Server blade.



