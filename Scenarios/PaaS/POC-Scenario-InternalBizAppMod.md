# POC Scenario Contoso Expenses: Deploying Website on Azure PaaS

# Abstract

During this module, you will learn about bringing together PaaS App Services components to build a sample application, Contoso Expenses, and making it scalable, highly available and secure.

# Learning objectives
After completing the exercises in this module, you will be able to:
* **Azure PaaS Fundamentals** – Base PaaS concepts, as well as features and frameworks for creating enterprise line-of-business applications on Azure or modernizing existing apps using Azure App Service (Web Apps and API Apps). 
* **Building on Azure App Service** - Design best practices and core principles for building new applications on Azure or moving existing applications to App Service. During this session, we will also build a web app reference PoC.

## Pre-Requisites
* To complete this PoC, you will need:
    * Visual Studio Team Services account.
        * If you don’t have one, you can create from [here](https://www.visualstudio.com/team-services/)
    * Visual Studio 2017
    * Download Proof-of-concept project from [here](https://1drv.ms/f/s!An-8SCAjWpl43TWoz4w1rRXutCkR)
    * Ensure the SSDT package is installed from [here](https://msdn.microsoft.com/en-us/mt186501.aspx)
    * During this lab, we are using the Contoso Expenses application for the hands-on-labs.

# Estimated time to complete this module:
Self-guided

## POC Steps
* Ensure you are logged into the github or your VSTS account.
    * Goto the Azure FastTrack Projects tab [here](https://azurefasttrack.visualstudio.com/_projects)

  ![Screenshot](/Images/AppMod-Pic-1.png)

  >   There are 3 three projects that are in Visual Studio.

    * (list them here)

## Build the Project in Visual Studio
  * Once you have downloaded the zip file for the POC Project, you may create a new project in VSTS and add this project to 
  Source Code control in VSTS using Visual Studio
  * Link to the PoC for Microsoft FTE [here](https://azurefasttrack.visualstudio.com/_projects)
  * For example, **FTAPOC** is the team project that is set up for FastTrack team members
  * **ContosoExpenses** is the Solution Name

  * Unzip the Proof-of-concept project to any folder.

    ![Screenshot](/Images/AppMod-Pic-2.png)

  * Open **Contoso.Expenses.sln** with Visual Studio.

    ![Screenshot](/Images/AppMod-Pic-3.png)

  * Navigate to the expense.sql file. This file will get executed post-deployment and add test data to the database.
  
    ![Screenshot](/Images/AppMod-Pic-4.png)
  
    Next, we will deploy the database into Azure SQL DB.  Navigate to the azure.portal [here](https://portal.azure.com)

  * Click on **"+"** and search for **Resourc Group**.

    ![Screenshot](/Images/AppMod-Pic-5.png)

  * Select **Resoure Group** and click **Create**.

    ![Screenshot](/Images/AppMod-Pic-6.png)

  * Enter **ContosoExpensesRB** as the name, click **Create**.

    ![Screenshot](/Images/AppMod-Pic-7.png)

  * Navigate to the resource group **ContosoExpensesRB**.

    ![Screenshot](/Images/AppMod-Pic-8.png)

  * Click **Add**, type in **SQL Server** to find **SQL Server**.
 
    ![Screenshot](/Images/AppMod-Pic-9.png)

  * Enter **contosoexpensesdb** as the Server Name and additionl information.

    ![Screenshot](/Images/AppMod-Pic-10.png)

  * Click **Create** to create a new SQL Server database.  The Azure alert bell will indicate the deployment is in progress.

    ![Screenshot](/Images/AppMod-Pic-11.png)

  * You now have a SQL Server database management container for all the databases underneath.

    ![Screenshot](/Images/AppMod-Pic-12.png)

  > Logical containers can contain 0 or many DBs.

# Add the Client IP in Firewall Settings for SQL Server
  * Add the IP address of the client you access the database from.
  * From the Azure portal, click on **Resource Groups**, **ContosoExpensesRB**, select the SQL Server **ContosoExpensesDB**, click on **Firewall**.

  ![Screenshot](/Images/AppMod-Pic-45.png)

  * Click on **Add client IP**. This will add your current IP as a rule name.

  ![Screenshot](/Images/AppMod-Pic-46.png)
 
# Publish the database project

  * Let's publish the database to Azure.  Capture the datatbase server name to the clipboard. Select the database **contosoexpensesdb** and click on **Properties**.

      ![Screenshot](/Images/AppMod-Pic-14.png)

  * Next, hightlight the **Server Name** and **Right-click** to select **Copy** to save it on the clipboard.

      ![Screenshot](/Images/AppMod-Pic-15.png)

        > What is a database DTU?
        Database Throughput Unit (DTU): DTUs provide a way to describe the relative capacity of a performance level of Basic, Standard, and Premium databases. DTUs are based on a blended measure of CPU, memory, reads, and writes.

  * From Visual Studio, **Right-click** on the project **Contoso.Expenses.Database** and select **Publish** to publish the database.

    ![Screenshot](/Images/AppMod-Pic-13.png)

  * Click **Edit**, then enter the **Server name**, **User name**, **Password**, and click **Ok**.

    ![Screenshot](/Images/AppMod-Pic-16.png)

  * Database information may already be filled in.
  
    ![Screenshot](/Images/AppMod-Pic-17.png)

  * Click on **Publish** to publish the database to Azure.
  
    ![Screenshot](/Images/AppMod-Pic-18.png)

  * The database will be published to Azure and give you the results.

    ![Screenshot](/Images/AppMod-Pic-19.png)

  * Let's look at the database using Visual Studio. From the VS IDE, click on **View** and select **SQL Server Object Explorer**.

      ![Screenshot](/Images/AppMod-Pic-20.png)

   * The database can be viewed from within Visual Studio.

      ![Screenshot](/Images/AppMod-Pic-21.png)

    * From Visual Studio, **Right-click** on **seed.sql** and select **Open** to view the seed data post deployment script.

        ![Screenshot](/Images/AppMod-Pic-22.png)

# Publish the web project

  * **Right-click** on the Web Project, **Contoso.Expenses.Web**.

      ![Screenshot](/Images/AppMod-Pic-24.png)

  * Select **Publish** from context menu.
  * Click on **Create new Profile** from the Publish dialog.

      ![Screenshot](/Images/AppMod-Pic-26.png)

  * Create a new **Azure App Service**, click **Ok**.

      ![Screenshot](/Images/AppMod-Pic-27.png)

  * Update the **Create App Service** settings.
  *Login into the correct **Subscription** from the dropdown list.
  * Set the **Web App Name**.
  * Select to the correct **Subscription** from the dropdown list.
  * Select to the correct **Resource Group** from the dropdown list.
  * Select to the correct **App Service Plan** from the dropdown list.
  * Click **Create**.

      ![Screenshot](/Images/AppMod-Pic-30.png)

  * Once the **App Service Plan** is created, click on **Publish**.

      ![Screenshot](/Images/AppMod-Pic-31.png)

  * The output window will give you progress of the deployment.

      ![Screenshot](/Images/AppMod-Pic-32.png)

  * Once deployed, you can launch the website by clicking on the URL.
  
      ![Screenshot](/Images/AppMod-Pic-33.png)
      ![Screenshot](/Images/AppMod-Pic-34.png)

 ## Update the Connection String in App Settings.
 
   * From the Azure Portal, click on **Resource Groups**, **ContosoExpensesRB**, select **Contoso.Expenses.Database**.

  ![Screenshot](/Images/AppMod-Pic-41.png)

  * From the SQL database page, **Click** on **Database Connection Strings**. Make sure to **highlight** the entire string, then **right-click** and click **copy**, to capture the database connection string.
  
  ![Screenshot](/Images/AppMod-Pic-25.png)

  * From the Azure Portal, click on **App Services**.

      ![Screenshot](/Images/AppMod-Pic-35.png)

  * Click on the **Name** of the App Service you deployed, then select **Overview**.

      ![Screenshot](/Images/AppMod-Pic-36.png)

  * Add the connection string to the database for this App Service.
  * Click on **Application Settings** under the **Settings** area.
  * Provide the connection string value in **Connection Strings** in the portal for the WebApp. Make sure that you set the type of the connection string to **Custom**.

 * Type **ContosoExpensesDataEntities** as the connection string name.
  * Update the **User ID** for your database username and **Password** to your database password.

      ![Screenshot](/Images/AppMod-Pic-40.png)
      ![Screenshot](/Images/AppMod-Pic-50.png)


## ************************************************
## ************************************************
## @Faiasl - To be Reviewed/Updated ASAP!!!
## ************************************************
## ************************************************

* Deploy and Publish the Application to Azure using Web Deploy 
* Walk through various settings and features in the portal ?
* Console, show Kudu?
* Create a Deployment Slot of Staging ?
* Make a code change and deploy to Staging Slot ?
* Deploy to the Staging Slot ?
* Perform a Slot Swap ?
* Monitoring and Diagnostics ?
* Automation using ARM Templates?
* SSL Certs?

## Useful References
* [Visual Studio Team Services, Getting Started](https://www.visualstudio.com/)
* [Visual Studio Team Services, Product Updates](https://www.visualstudio.com/team-services/updates/)
* [Visual Studio Team Services, Support](https://www.visualstudio.com/team-services/support/)
