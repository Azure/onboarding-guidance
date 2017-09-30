# POC Scenario: Running WordPress on Azure

## Table of Contents

<!-- * [Introduction](#Introduction) -->
* [Abstract](#Abstract)
* [Learning objectives](#Learning-objectives)
* [How to install WordPress on Azure WebApps](#How-to-install-WordPress-on-Azure-WebApps) 
* [Configuring WordPress on Azure WebApps](#Configuring-WordPress-on-Azure-WebApps)
* [Best Practices for running WordPress on Azure WebApps](#Best-Practices-for-running-WordPress-on-Azure-WebApps)
* [Migrating WordPress Site](#Migrating-WordPress-Site)
* [Optional: WordPress site with MySQL db on IaaS VM](#Optional:-WordPress-site-with-MySQL-db-on-IaaS-VM)
* [Optional: Adding Custom Domain](#Optional:-Adding-Custom-Domain)
* [Optional: Adding TLS](#Optional:-Adding-TLS)

<!-- ## Introduction -->

#### Abstract
Your digital marketing solution allows your organization to engage with customers around the world with rich, personalized digital marketing experiences. Azure provides a scalable, secure, and easy-to-use environment to build your digital marketing sites using WordPress, quickly launch digital campaigns that automatically scale with customer demand, and analyze the effectiveness of those campaigns with data analytics.

#### Learning objectives

* Understanding Azure App Service platform and installing/configuring WordPress on Web Apps
* Implementing various best practices to run WordPress on Azure
* How to migrate your existing WordPress site from on-premises or colo to Azure
* Deploying WordPress site with MySQL database on Azure IaaS VMs
* Adding custom domain to your WordPress site
* Adding TLS (SSL) to your WordPress Site

#### How to install WordPress on Azure WebApps

* Navigate to Azure Portal
* Click on + New, type WordPress in the search area, press Enter
* Select WordPress, click Create
* Enter **App name** (example: fasttrackdemo) for your WordPress site, it will validate to make sure the sub domain name available under azurewebsites.net
* Select your **Subscription**
* For **Resource Group** Create new for this demo (example:fastttackdemo-test-rg)
* For **Database Provider** select **Azure Database for MySQL (Preview)** for this demo
* Select **App Service Plan/Location**, click Create New, enter 
    * App Service Plan: **fastttackdemo-asp**
    * Location: **West US**
    * Pricing tier: **S1 Standard**
    * Click **OK**
    * ![Screenshot](../../Images/WordPress/wp-1.png)

* Select Database, etner
    * Server name: **fasttrackdemo-mysqldbserver**
    * Server admin login name: **your admin user name**
    * Password: **your strong password**
    * Confirm password: **your strong password**
    * Version: **5.7 or latest version**
    * Pricing Tier: **Basic**
        * Compute Units: **50**
        * Stroage (GB): **50**
    * **OK**
    * ![Screenshot](../../Images/WordPress/wp-2.png)

* Application Insights: **Off**

* Click **Create** 
* ![Screenshot](../../Images/WordPress/wp-3.png)



#### Configuring WordPress on Azure WebApps

* Once the WordPress deployment succeeded, from the left navigation bar in the portal, select **App Services**, then select **fasttrackdemo** web app, then click on the URL: http://fasttrackdemo.azurewebsites.net
    * ![Screenshot](../../Images/WordPress/wp-4.png)

* This will take you to the initial configuration page:  http://fasttrackdemo.azurewebsites.net/wp-admin/install.php. Select **English (United States)** click **Continue**
    * ![Screenshot](../../Images/WordPress/wp-5.png)

* In the next Information needed page, enter
    * Site Title: **FastTrack Demo**
    * Username: **your user name**
    * Password: **your strong password**
    * Your Email: **your email address**
    * Click on **Install WordPress**
    * ![Screenshot](../../Images/WordPress/wp-6.png)

* If all goes well you should see **Success!** page
    * ![Screenshot](../../Images/WordPress/wp-7.png)

* Click **Login**. Login with Username & Password created in the previous step

* This will take you to Dashboard page
    * ![Screenshot](../../Images/WordPress/wp-8.png)

* To change **Themes**, select **Appearance** then **Themes**. Select **Twenty Sixteen** then click **Activate**
    * ![Screenshot](../../Images/WordPress/wp-9.png)

* Now visit the site, by selecting **Visit Site** option from top left corner. This will take you to: http://fasttrackdemo.azurewebsites.net/ 

* Your WordPress site should look like:
    * ![Screenshot](../../Images/WordPress/wp-10.png)

* Before we add any Posts & Pages, lets configure WordPress with some best practices

#### Best Practices for running WordPress on Azure WebApps



#### Migrating WordPress Site

#### Optional: WordPress site with MySQL db on IaaS VM

#### Optional: Adding Custom Domain

#### Optional: Adding TLS
