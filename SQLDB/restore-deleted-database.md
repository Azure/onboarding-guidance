# Fast Track for Azure - SQL Database

This folder is work in progress, please stay tuned! 

# Abstract

During this module you will learn how to restore a database to a logical Azure SQL Database server.  Restoring a deleted database can only be done to the same server it was deleted from and this process will create a new databse from a backup created during deletion.

# Learning Objectives

By the end of this module you will be able to:
* Restore a deleted database to an existing logical Azure SQL Database Server

## Pre-Requisites
* To complete this module you should have:
    * Completed the module *Create a Sample Azure SQL DB*

# Estimated time to complete this module:
Self-guided (15 minutes approx)


# Checking for an existing backup

Before continuing you need to delete the database that you created in earlier.  Before deleteing the database you need to ensure that teh database has been backed up by the Azure SQL Server.  To do this you need to:

* Go to the Azure portal [ms.portal.azure.com](http://ms.portal.azure.com)
* From the left hand navigation menu select **SQL Databases**
* Select the AdventureWorksLT database that you previously created
* From the Database blase, select the **Restore** button fom the top menu

![Screenshot](/Images/SQLDB-click-restore.png)

If the server has not created a backup yet then you will not be able to do a restore.  If there is no backup you will see this message:

![Screenshot](/Images/SQLDB-no-restore-yet.png)

If you see this message then you just need to wait a short while until the system takes a backup.  Databases are backedup when they are initially created, but this schedule may take 15 minutes to kick in.  If you don't see this message then you are good to delete.

# Deleting the Database

To delete the database you need to:

* click on the Delete button in the top menu of the current screen
* Press *yes* on the next prompt

The Database will now be deleted but it make take a couple of minutes for the option to restore the database to become avaiable.

# Restoring a Deleted Database

To restore a previously deleted database you need to:

* Search for **SQL Servers** using the search box at the very top of the portal
* Click on **SQL Servers** in the results
* Click on the Logical SQL Server in the servers blade.
* From the Settings menu of the Server, select the *deleted databases* option

![Screenshot](/Images/SQLDB-deleted-option.png)

Providing a few minutes have passed since you deleted the databse, the deleted database will appear in the list.  

* Click the database to bring up the restore menu 
* Name the databse *AVWorks*
* Click OK to start the restore.

>**NOTE**
> You can't change the point in time for teh restore, it will restore the database to the last know backup point, which willlbe the time at which the databse was deleted.
