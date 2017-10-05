# POC Scenario Contoso Expenses: Deploying Website on Azure PaaS

# Abstract

During this module, you will learn about bringing together PaaS App Services components to build a sample application, Contoso Expenses, and making it scalable, highly available and secure.

# Learning objectives
After completing the exercises in this module, you will be able to:
* **Azure PaaS Fundamentals** – Understand base PaaS concepts, as well as features and frameworks for creating enterprise line-of-business applications on Azure or modernizing existing apps using Azure App Service (Web Apps and API Apps). 
* **Building on Azure App Service** - Apply design best practices and core principles for building new applications on Azure or moving existing applications to App Service. During this session, we will also build a web app reference PoC.

## Pre-Requisites
* To complete this PoC, you will need:
    * Visual Studio 2017
    * Download Proof-of-concept project from [here](https://fasttrackforazure.blob.core.windows.net/sourcecode/Contoso.Expenses.zip)
      
# Estimated time to complete this module
3.5 hours

## Open application with Visual Studio
* Copy the project to a working folder.
* From the working folder, open **Contoso.Expenses.sln** with Visual Studio.

  ![Screenshot](../../Images/AppMod-Pic-0100.png)

* Build the Project in Visual Studio.
  * **Right-Click** on the Solution **Contoso.Expenses**, select **Build Solution**.

  ![Screenshot](../../Images/AppMod-Pic-0102.png)

  * There are 4 projects that are in Visual Studio.
  * **Contoso.Expenses.API** - This is a Web API project that provides helper logic to the main web app.
  * **Contoso.Expenses.DataAccess** - This is a Class Library that utilizes Entity Framework.
  * **Contoso.Expenses.Database** - This is a Database project that contains the SQL to create the Expenses table and SQL to initially seed default data.
  * **Contoso.Expenses.Web** - This is the Internal Business Web App.

## Create the SQL Database
* Navigate to the Azure portal.
* Click on **+ New**, type in **Resource Group** in the search area, press **Enter**.
* Click on **Resource Group**, click on **Create**.
* Enter a descriptive name (e.g. **ContosoExpenses-RG-WestUS2**) as the **Resource group name**.
* Select your **Subscription**.
* Select your **Resource Group Location** (e.g. West US 2).
* Click **Create**.

  ![Screenshot](../../Images/AppMod-Pic-0104.png)

* Navigate to the resource group **ContosoExpenses-RG-WestUS2**.

  ![Screenshot](../../Images/AppMod-Pic-0106.png)

* Click **+Add**, type in **SQL Database** in the search area, press **Enter** and click on **SQL Database**.

  ![Screenshot](../../Images/AppMod-Pic-0108.png)

* Click **Create**.
* Enter **contosoexpensesdb** as the **Database Name**.
* For **Resource Group**, select **Use Existing**, then select the **Resource Group** created earlier (e.g. ContosoExpenses-RG-WestUS2).
* For **Server**, click **Configure required settings**.
* Click **Create a new Server**.
* For **Server Name**, enter **contosoexpensesdbserver1**.
  * Note: The server name needs to be globally unique, so add a number to the end of name.
* Enter a **Server admin login** and **Password**.
  * Note: Save the **Login name** and **Password**, as you’ll need it later.
* For Location select the same location as before (e.g. **West US 2**).
* Click **Select** to save the server settings.

  ![Screenshot](../../Images/AppMod-Pic-0110.png)

* Click on **Pricing Tier**.
* Move the **DTU** slider to **20**.
  * Note: DTU's are Database Transaction Units and measure database performance with a blended measure of CPU, memory, I/O.  For more information on DTU's, see [Explaining Database Transaction Units](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-what-is-a-dtu).

* Move the **Storage** slider to **5**.
* Click **Apply**.
* Click **Create** to create a new SQL Database Server & Database.

  ![Screenshot](../../Images/AppMod-Pic-0111.png)

  * Note: The Azure alert bell will indicate that the deployment is in progress.

  ![Screenshot](../../Images/AppMod-Pic-0112.png)

## Client IP in Firewall Settings for SQL Server
To add the **IP address** of the client you access the database from, do the following steps:
* Under the SQL Server Settings, click on **Firewall**.
* Click on **Add client IP** and click **Save**. This will add your current IP as a new rule on the Firewall.

  ![Screenshot](../../Images/AppMod-Pic-0116.png)

## Publish the Database into Azure SQL DB
* From Visual Studio, expand the project **Contoso.Expenses.Database**.
* Click on the **Seed.sql** file under the **Scripts folder**, and look at content in the preview window.
  * Note: This file will get executed post-deployment and add test data to the database.

  ![Screenshot](../../Images/AppMod-Pic-0118.png)

* **Right-click** on the project **Contoso.Expenses.Database** and select **Publish** to publish the database.

  ![Screenshot](../../Images/AppMod-Pic-0120.png)
  ![Screenshot](../../Images/AppMod-PublishDatabaseScreen.png)
  
* On **Target database connection** click **Edit**, then click **Browse**.

* From the list presented, expand **Azure**.
* Select the **Database** created on the SQL Server in the previous steps.

  ![Screenshot](../../Images/AppMod-Pic-0122.png)

* For the **Server Name**, confirm or enter the server name previously saved to the clipboard (e.g. **contosoexpensesdbserver1.database.windows.net**).
* Set **Authentication** to **SQL Server Authentication**.
* Enter the database server **User Name** and **Password**. Select the checkbox **Remember Password**.
* Select the database name **contosoexpensesdb**.
* Click **Test Connection**.
* You may get prompted to add a firewall rule so that your computer is allowed to access the database server. If so, click **Ok** to allow the firewall rule to be created.

  ![Screenshot](../../Images/AppMod-Pic-0123.png)
* The result should be **Test connection succeeded**, then click **Ok**.
* Click **Ok** to close the connect window.

* Click on **Publish** to publish the database to Azure.
  * The database will be published to Azure and give you the results.

  ![Screenshot](../../Images/AppMod-Pic-0124.png)

* The status and progress will be displayed in the Data Tools Operations window.

  ![Screenshot](../../Images/AppMod-Pic-0125.png)

## View the database using Visual Studio Tools
* From **Visual Studio**, select **View** | **SQL Server Object Explorer**.
* Expand the **SQL Server** node to view the connection.
* Expand the connection **contosoexpensesdbserver1.database.windows.net**, and then **Databases | contosoexpensesdb | Tables**. Confirm the existence of the **dbo.Expense** table.

  ![Screenshot](../../Images/AppMod-Pic-0130.png)

## Publish the Business Web App

* From Visual Studio, **right-click** on the Web Project, **Contoso.Expenses.Web**.
* Select **Publish** from context menu, to pick a new publish target.

  ![Screenshot](../../Images/AppMod-Pic-0132.png)

* Click on **Create new Profile** from the **Publish dialog**.

  ![Screenshot](../../Images/AppMod-Pic-0134.png)

* Create a new **Microsoft Azure App Service**, click **Ok**.

  ![Screenshot](../../Images/AppMod-Pic-0136.png)

## Create App Service
* Login into the correct **Subscription** from the dropdown list.
* Set the **Web App Name** to any name, e.g. **ContosoExpenesesWeb20170710012420**
* Select the correct **Subscription** from the dropdown list.
* Select the correct **Resource Group** from the dropdown list, e.g. **ContosoExpenses-RG-WestUS2**.

  ![Screenshot](../../Images/AppMod-Pic-0138.png)

* For the App Service Plan, click **New**.
* To configure the app service plan, enter a name or use the default. e.g. **ContosoExpensesWeb20170710012420Plan**.
* For **Location**, select your location. e.g. **West US 2**.
* For **Size**, select **S1 (1 core, 1.75 GB RAM)**.
* Click **OK**.

  ![Screenshot](../../Images/AppMod-Pic-0139.png)

* Make sure the correct **App Service Plan** is selected in the dropdown list. e.g. **ContosoExpensesWeb20170710012420Plan**.
* Click **Create**.

  ![Screenshot](../../Images/AppMod-Pic-0140.png)

* Once the **App Service Plan** is created, click on **Publish**.

  ![Screenshot](../../Images/AppMod-Pic-0141.png)

  * The output window will give you progress of the deployment.

  ![Screenshot](../../Images/AppMod-Pic-0142.png)
  
  * At the end of the deployment, Visual Studio should automatically launch your default browser to show your published web app.

## Launch the website from the Azure Portal
* Navigate to the **Azure portal**.
* Click on **Resource Group**, select **ContosoExpenses-RG-WestUS2**.
* Click on the **App Service name** you deployed, e.g. **ContosoExpensesWeb20170710012420**.

  ![Screenshot](../../Images/AppMod-Pic-0143.png)

* Click on **Overview** then the **URL** to launch the website.

  ![Screenshot](../../Images/AppMod-Pic-0144.png)
  
  ![Screenshot](../../Images/AppMod-Pic-0146.png)

## Update the Connection String in App Settings
* First, let's capture the database server name to the clipboard.
  * Go back to the list of **Resource Groups**.
  * Click on **ContosoExpenses-RG-WestUS2**.
  * Click on **contosoexpensesdbserver**.
  * Click on **Properties**.
  * Highlight the database Server Name and **right-click** to select **Copy** to save it on the clipboard.

  ![Screenshot](../../Images/AppMod-Pic-0150.png)

* Navigate back to your **Resource Group**.
* Click on the **App Service name** you deployed, e.g. **ContosoExpensesWeb20170710012420**.
* From the Settings area, click on **Application settings**.
* On the **Connection strings** area, type **ContosoExpensesDataEntities** as the connection string name.

  ![Screenshot](../../Images/AppMod-Pic-0152.png)

* Provide the connection string value in Connection Strings in the portal for the WebApp.
  * Note: Modify the following <**marked**> items with your server name, database name and login credentials, used in above steps.
  * Hint: **Copy** the following connection string into **Notepad**, then replace the 4 bolded areas with your information.
  
   ```
    metadata=res://*/Models.ContosoExpensesModel.csdl|res://*/Models.ContosoExpensesModel.ssdl|res://*/Models.ContosoExpensesModel.msl;provider=System.Data.SqlClient;provider connection string="data source=tcp:contosoexpensesdbserver1.database.windows.net;initial catalog=contosoexpensesdb;Integrated Security=False;User Id=Username;Password=Password;MultipleActiveResultSets=True;App=EntityFramework"
   ```

   ![Screenshot](../../Images/AppMod-Pic-0154.png)

* **Copy** the new connection string from Notepad into the clipboard.
* **Paste** into the **Value** textbox, alongside of the name **ContosoExpensesDataEntities** entered above.
* Select **Custom**, from the dropdown list.
* Click on **Save**.

    ![Screenshot](../../Images/AppMod-Pic-0156.png)

## Deploy the API app
* From Visual Studio, **right-click** on the Web Project, **Contoso.Expenses.API**.
* Select **Publish** from context menu, to pick a new publish target.

  ![Screenshot](../../Images/AppMod-Pic-0160.png)

* Click on **Create new Profile** from the **Publish dialog**.

  ![Screenshot](../../Images/AppMod-Pic-0162.png)

* Create a new **Microsoft Azure App Service**, click **Ok**.

  ![Screenshot](../../Images/AppMod-Pic-0136.png)

## Create App Service
* Login into the correct **Subscription** from the dropdown list.
* Set the **API App Name** to any name, e.g. **contosoexpensesapi20170711011807**
* Select the correct **Subscription** from the dropdown list.
* Select the correct **Resource Group** from the dropdown list, e.g. **ContosoExpenses-RG-WestUS2**.
* Select the correct **App Service Plan** from the dropdown list, e.g. **ContosoExpensesWeb20170710012420Plan** from a previous step.
* Click **Create**.

  ![Screenshot](../../Images/AppMod-Pic-0164.png)

* Once the **App Service Plan** is created, click on **Publish**.

  ![Screenshot](../../Images/AppMod-Pic-0166.png)

  * The output window will give you progress of the deployment.

  ![Screenshot](../../Images/AppMod-Pic-0168.png)
  
  * At the end of the deployment, Visual Studio should automatically launch your default browser to show your published web app.

## Update the App Service Settings
* From the Azure Portal, click on **Resource Groups**.
* Click on **ContosoExpenses-RG-WestUS2**.
* Click on the **App Service** you deployed for the API app, e.g. **ContosoExpensesAPI20170711011807**.
* Click on **Overview** and copy the URL to the clipboard.

  ![Screenshot](../../Images/AppMod-Pic-0170.png)

* Go back to the **Resource Group** and now select the **App Service** for the Expense web app, e.g. **ContosoExpensesWeb20170710012420**.
* From the **Settings area**, click on **Application Settings**.
* Under **App settings**, add two new entries in the first and second textboxes.
  * Type **EmployeeName** and <**your name**>.
  * Type **EmployeeApiUri** and paste in the URL of the API app, e.g. **http://contosoexpensesapi20170711011807.azurewebsites.net**
* Click **Save**.

  ![Screenshot](../../Images/AppMod-Pic-0172.png)

## Create a Storage Account
* From the Azure Portal, click on **Resource Groups**, **ContosoExpenses-RG-WestUS2**.
* Click on the **+ Add**, type **Storage** and press **Enter**.
* Click on **Storage Account  - blob, file, table, queue**.
* Click on **Create**.

  ![Screenshot](../../Images/AppMod-Pic-0180.png)

* Type in **contosoexpensesUNIQUEIDsa** (e.g. **contosoexpenses123sa**) for the **Name**. The name of a storage account needs to be globally unique.
* If needed, change **Replication** to **Locally-redundant storage (LRS)**.
* Make sure you select the correct **Resource Group** and **Location** as before.
* Leave other fields with default options.
* Click on **Create**.

  ![Screenshot](../../Images/AppMod-Pic-0182.png)

## Update the web.config for Storage Account
* From the Azure Portal, click on **Resource Groups**, **ContosoExpenses-RG-WestUS2**.
* Click on the **Storage Account** you deployed, e.g. **contosoexpensessa**.
* Under **Settings**, click on **Access keys**.

  ![Screenshot](../../Images/AppMod-Pic-0186.png)

* From **Key1**, copy the **Key** to the clipboard, paste into a Notepad.
* From **Key1**, copy the **Connection** to the clipboard, paste into a Notepad.

  ![Screenshot](../../Images/AppMod-Pic-0188.png)
  
* From **Visual Studio**, open up the **web.config** under **Contoso.Expenses.Web**.
* Scroll down and locate **StorageConnectionString**, then paste the connection string from the clipboard between the quotes. Save the changes on the file.

  ![Screenshot](../../Images/AppMod-Pic-0190.png)

## Setup a Sendgrid Email Account
* From the Azure Portal, click on **Resource Groups**, **ContosoExpenses-RG-WestUS2**.
* Click on the **+ Add**, type **SendGrid** and press **Enter**.
* Click on **SendGrid Email Delivery**.
* Click on **Create**.

  ![Screenshot](../../Images/AppMod-Pic-0194.png)

* Type **DemoSendGridEmail** for the **Name**.
* Type in a **Password**.
* Select the **Subscription**.
* Select the **Use existing** for the resource group.
* Click on **Pricing Tier**, select **F1 Free**.
* Click **Select**.

  ![Screenshot](../../Images/AppMod-Pic-0196.png)

* Click on **Contact Information**.
* Enter **First Name**, **Last Name**, **Email**, **Company**.
* Click **Ok**.

  ![Screenshot](../../Images/AppMod-Pic-0198.png)

* Click on **Legal Terms**, view, then click **Purchase**.

  ![Screenshot](../../Images/AppMod-Pic-0200.png)

* Click **Create**, to create the SendGrid Email Account.


  ![Screenshot](../../Images/AppMod-Pic-0202.png)

## Create an Azure Function
* From the Azure Portal, click on **Resource Groups**, **ContosoExpenses-RG-WestUS2**.
* Click on the **+ Add**, type **Function App** and press **Enter**.
* Click on **Function App**.
* Click **Create**.

  ![Screenshot](../../Images/AppMod-Pic-0210.png)

* Enter **ContosoExpensesUNIQUEIDFunction** for the **App Name**. The Function App name needs to be globally unique.
* For **Location** select **West US 2** (or the same used previously).
* For **Storage**, select **Select existing**, and select from the dropdown list the storage account previously created (e.g. **contosoexpensessa**).
* Leave other fields with the defaults.
* Click on **Create**.

  ![Screenshot](../../Images/AppMod-Pic-0212.png)

* You may get an error under certain circumstances that the Function App could not be created with a **Consumption** pricing tier.

  ![Screenshot](../../Images/AppMod-Pic-0213.png)

  * This is a temporary constraint that will get resolved over time; open the URL mentioned in the error message to learn more.
  * If you have this situation, simply change the **Hosting Plan** to an **App Service Plan** instead of a **Consumption Plan**.

* From the Azure Portal, click on **Resource Groups**, **ContosoExpenses-RG-WestUS2**.
* Click on the **Function** you just created, e.g. **ContosoExpensesFunction**.
* Click on **Functions +**, to add a new function.

  ![Screenshot](../../Images/AppMod-Pic-0214.png)

* Scroll down and click on **Custom Function**.

  ![Screenshot](../../Images/AppMod-Pic-0216.png)

* Click on **Queue Trigger – C#**.
* Scroll down and type in **QueueTriggerContosoExpenses** for the Name your Function.
* Set the **Queue name** to **contosoexpenses**.
* Click **Create**.

  ![Screenshot](../../Images/AppMod-Pic-0218.png)

* Delete everything from the textbox.
* Copy the following into the clipboard, then paste into text area.

 ```
#r "Newtonsoft.Json"
#r "SendGrid"

using System;
using System.Net;
using Newtonsoft.Json;
using SendGrid.Helpers.Mail;

public class ExpenseExtended
{
    public int ExpenseId { get; set; }
    public string Purpose { get; set; }
    public Nullable<System.DateTime> Date { get; set; }
    public string Cost_Center { get; set; }
    public Nullable<double> Amount { get; set; }
    public string Approver { get; set; }
    public string Receipt { get; set; }
    public string ApproverEmail { get; set; }
}

public static async Task Run(string expenseItem, TraceWriter log, IAsyncCollector<Mail> emailMessage)
{
    var expense = JsonConvert.DeserializeObject<ExpenseExtended>(expenseItem);

    var emailFrom = "expense@contoso.com";

    var emailTo = expense.ApproverEmail;
    var emailBody = $"Hello {expense.Approver}, \r\n New Expense report submitted for the purpose of: {expense.Purpose}. \r\n Please review as soon as possible.\r\n This is a auto generated email, please do not reply to this email";
    var emailSubject = $"New Expense for the amount of ${expense.Amount} submitted";

    log.Info($"Email To: {emailTo}");
    log.Info($"Email Subject: {emailSubject}");
    log.Info($"Email Body: {emailBody}");

    Mail expenseMessage = new Mail();
    var personalization = new Personalization();
    personalization.AddTo(new Email(emailTo));
    expenseMessage.AddPersonalization(personalization);

    var messageContent = new Content("text/html", emailBody);
    expenseMessage.AddContent(messageContent);
    expenseMessage.Subject = emailSubject;
    expenseMessage.From = new Email(emailFrom);

    await emailMessage.AddAsync(expenseMessage);
}
 ``` 

  ![Screenshot](../../Images/AppMod-Pic-0220.png)

* Click **Save**.

* In the left panel, click on **Integrate**.
* Type in **expenseItem** for the **Message Parameter Name**.
* For the **Storage Account Connection**, Click on **New**.
* Select an existing storage account name. e.g. **contosoexpensessa**.
* Click **Save**.

  ![Screenshot](../../Images/AppMod-Pic-0222.png)

* From the Azure Portal, click on **Resource Groups**, **ContosoExpenses-RG-WestUS2**.
* Select the **DemoSendGridEmail** SendGrid Account.
* Under **Settings**, click on **Configurations**.
* Copy the **Username** to the clipboard.
* Using a browser, navigate to **http://app.sendgrid.com**.
* Login using the **Username** from clipboard and type the **Password** you created earlier.
  * You will see the Sendgrid dashboard/portal.

  ![Screenshot](../../Images/AppMod-Pic-0224.png)

* From the left-hand panel, click on **Settings** | **API Keys**.
* Click the button **Create API Key**.

  ![Screenshot](../../Images/AppMod-Pic-0225.png)

* Type in **SendGridAPIKey** for the **API Key Name**.
* Select **Full Access**, then click **Create & View**.

  ![Screenshot](../../Images/AppMod-Pic-0226.png)

* Click on the generated key and copy to the clipboard, paste it into Notepad.
  * Note: This key will **NOT** be available to copy after this blade is closed.
* Click **Done**.

    ![Screenshot](../../Images/AppMod-Pic-0227.png)

* From the Azure Portal, click on **Resource Groups**, **ContosoExpenses-RG-WestUS2**.
* Select the **ContosoExpensesFunction** function app.
* From the left side panel, select **QueueTriggerContosoExpenses** | **Integrate**.
* Click on **Outputs** | **+ New Output** | **SendGrid**, click **Select**.

  ![Screenshot](../../Images/AppMod-Pic-0228.png)

* Enter **emailMessage** in the Message Parameter Name, click **Save**.

  ![Screenshot](../../Images/AppMod-Pic-0230.png)

* Click on the **ContosoExpensesFunction** (lighting bolt) Function App.
* From the top menu bar, click on **Settings**.
* Under **Applications Settings**, click **Manage Application Settings**.

  ![Screenshot](../../Images/AppMod-Pic-0232.png)

* Scroll down to **App Settings**.
* Add new setting, type in **SendGridApiKey** in the **Key** field, and paste in the generated key copied to the clipboard from above step to the **Value** field.
* Click **Save**.

  ![Screenshot](../../Images/AppMod-Pic-0234.png)

* Close this blade by clicking on the **X** from upper right-hand corner.
* In the left panel, click on **Integrate**, notice under Outputs you will see **SendGrid (emailMessage)** shows up.
  * Note: What this function is doing is monitoring at the storage queue called **contosoexpenses**. Every time a message comes in to that queue, this function will pick that message up and email it to an email address.

  ![Screenshot](../../Images/AppMod-Pic-0236.png)

## Review the Contoso.Expenses.API app
* In Visual Studio, select the project **Contoso.Expenses.API**.
* Expand the **Controllers folder**, click on **EmployeeController.cs** file.
  * On line **#35** you will see name **Randy**.
  * Feel free to modify this for your own user name that you have entered in the web app's application settings before.
* Right-click on the project **Contoso.Expenses.API**, select **Publish**.
* Verify the publish profile is the one previously created (e.g. **contosoexpensesapi20170711011807**), and click **Publish**.
* Once published, copy the URL in the output folder and paste it into a browser. e.g. **http://contosoexpensesapi20170711011807.azurewebsites.net**.

## Testing out the API with Swagger
* In the browser, add **/swagger** to the end of the URL, and press enter.
  * e.g. **http://contosoexpensesapi20170711011807.azurewebsites.net/swagger**
  * This will load the Swagger page that will allow you to explore and test your APIs.
* Click on **Employee**, and then click on **GET**.
* Under **Parameters,** type in **Randy** for the **employeeName** parameter and then click **Try it Out!**

  ![Screenshot](../../Images/AppMod-Pic-0240.png)

  * The response body will return **ManagerName** with a response code of 200.

  ![Screenshot](../../Images/AppMod-Pic-0241.png)

## Test out the Website
* From Visual Studio, right-click on the Web Project, **Contoso.Expenses.Web**.
* Select **Publish** from context menu, to pick a new publish target.
* Select the previously used Profile from the Publish dialog and click on **Publish**.
  * This publishes the change to the **Web.config** file to use the correct **StorageConnectionString**.
  * Alternatively, you could update the setting directly in the Azure portal for the web app, under the **Application settings** as before.
* From the Azure Portal, click on **Resource Groups**.
* Click on **ContosoExpenses-RG-WestUS2**.
* Click on the **App Service** you deployed, e.g. **ContosoExpensesWeb20170710012420**.
* Click on URL to launch the website. e.g. **http://contosoexpensesweb20170710012420.azurewebsites.net/**.
* From the website, click on **Expenses**.
* Click on **Create New**.

  ![Screenshot](../../Images/AppMod-Pic-0244.png)

* Type in values for a test record and click **Create**.
  ![Screenshot](../../Images/AppMod-Pic-0245.png)
  ![Screenshot](../../Images/AppMod-Pic-0246.png)

## View the Queue from Visual Studio
* From Visual Studio, select the menu item **View** | **Cloud Explorer**.
* Select the correct subscription, and click **Apply**.

  ![Screenshot](../../Images/AppMod-Pic-0250.png)

* Expand the nodes to **Storage Accounts** | YourStorageAccountName (e.g. contosoexpensessa) | **Queues**.
* Right-click on **contosoexpenses** and select **Open Queue Editor**.
  * Note: The email message has been processed and de-queued.

    ![Screenshot](../../Images/AppMod-Pic-0252.png)

## Coming soon...
* Console, show Kudu!
* Deployment Slots for Staging!
* Deployment Slot Swap!
* Monitoring and Diagnostics!
* Automation using ARM Templates!
* SSL Certs!

## Useful References
* [Visual Studio Team Services, Getting Started](https://www.visualstudio.com/)
* [Visual Studio Team Services, Product Updates](https://www.visualstudio.com/team-services/updates/)
* [Visual Studio Team Services, Support](https://www.visualstudio.com/team-services/support/)
