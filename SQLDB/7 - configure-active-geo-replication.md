 # Fast Track for Azure - SQL Database

This folder is work in progress, please stay tuned! 

# Abstract

During this module you will learn how to configure an exisrting Azure SQL Database for Active Geo-replication between two regions

# Learning Objectves

By the end of this module you will be able to:

* Configure Active Geo-replication on an existing Azure SQL Database between two Azure regions
* Manually Fail over the database to another region

## Pre-Requisites

* To complete this module you will need to:
    * Completed either the create a sample database walk thorugh or import a database into Azure SQL Database

# Estimated time to complete this module:
Self-guided (20 minutes approx)

# Configure Active-Geo Replication

You configure active geo-replication from the Database balde in the portal.  Start by:

* Clicking on the SQL Databases option in the laft hand navigation bar
* Select the *AVWorks* Database from the list presented
* Under settings, select *Geo-Replication*

You will now see the geo-replication screen which shows a map of the world, the location of your current database and the regions that you can replicate it to.  It will also show you a recommendation of wheer to replicate this particular database, which is based on Azure datacentre pairing.

![Screenshot](/Images/SQLDB-initial-geo-replication.png)

To set-up geo-replication you should now:

* Select any other Azure Datacentre (East US in this example)
* Create a new server in the new window
* Leave the database as *readable*
* Select S2 for the pricing Tier
* Press OK to start the deployment

![Screenshot](/Images/SQLDB-geo-replication-secondary.png)

At this stage you will see a dotted line betweent he 2 selected data centres while the database is seeded on the new location anf mirroring is set-up.

![Screenshot](/Images/SQLDB-geo-replication.png)

Once the database replication has competed, the dotted line with turn solid.

# Fail-over the databases

From the geo-replciation screen:

* Click the 3 dots to the right of the secondary server to expose the context menu
* Click on *Fail-over*
* Select *yes* from the confirmation menu

![Screenshot](/Images/SQLDB-db-failover.png)

Once you hit yes on the confirmation screen, you will see the dotted line reappear between the 2 data centres with the direction changed.  Once the failover has taken place (this can take a short while) the line will return to solid


