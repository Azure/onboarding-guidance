# POC Scenario: Running WordPress on Azure

## Table of Contents

<!-- * [Introduction](#Introduction) -->
* [Abstract](#abstract)
* [Learning objectives](#learning-objectives)
* [How to install WordPress on Azure WebApps](#how-to-install-wordpress-on-azure-webapps) 
* [Configuring WordPress on Azure WebApps](#Configuring-WordPress-on-Azure-WebApps)
* [Best Practices for running WordPress on Azure WebApps](#Best-Practices-for-running-WordPress-on-Azure-WebApps)
* [Creating a sample Post](#Creating-a-sample-Post)
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

* Your WordPress site should look like this:
    * ![Screenshot](../../Images/WordPress/wp-10.png)

* Before we add any Posts & Pages, lets configure WordPress with some best practices

#### Best Practices for running WordPress on Azure WebApps

In this section, we will configure WordPress with few best practices.

* **Disable ARR cookie**: Azure Websites makes great use of the Application Request Routing IIS Extension to distribute connections between active instances. ARR helps keep track of users by giving them a special cookie (known as an affinity cookie) that allows Azure Websites to know upon subsequent requests which server instance handled previous requests by the same user. This way, we can be sure that once a client establishes a session with a specific server instance, he will keep talking to the same server as long as his session is active. This is of particular importance for session-sensitive applications (a.k.a. state full application). Because WordPress is stateless by default and stores all the session information in the database, it does not require clients to connect to the same web server instance. Disabling the ARR cookie will improve performance when running a WordPress site on multiple instances.
To disable ARR cookie:
    * Login to the [Azure portal](http://portal.azure.com/)
    * Go to App Services and select you **fasttrackdemo** web app
    * Select **Application settings**, find **ARR Affinity** and click **Off**
    * ![Screenshot](../../Images/WordPress/wp-11.png)
    * Click **Save** on the top

* **Azure Blob storage for Media Content**: If your WordPress site is heavy with Video and Images content, we recommend using a blob storage to store all your media content. To learn to create an Azure Storage account, see [How to create an Azure Storage account](https://docs.microsoft.com/en-us/azure/storage/common/storage-create-storage-account). Once you have created the account, activate and configure [Windows Azure Storage for WordPress plugin](https://wordpress.org/plugins/windows-azure-storage/) for your WordPress website.
    * Make sure to [Create Storage Account and a Blob Container](https://docs.microsoft.com/en-us/azure/storage/common/storage-create-storage-account) first before proceeding to next step.
    * Once Storage Account created, go to WordPress site Dashboard page. For example: (http://fasttrackdemo.azurewebsites.net/wp-admin/)
    * Click on **Plugins**, then **Add New**
    * In the **Search plugins**, enter **Windows Azure Storage for WordPress**
    * Click **Install Now**
    * ![Screenshot](../../Images/WordPress/wp-12.png)
    * Once successfully installed, Click **Activate**
    * From WordPress Dashboard page, go to **Settings**, click **Windows Azure**, enter the following:
        * Store Account Name: **your storage account name**
        * Store Account Key: **one of the storage access key**
        * Use Windows Azure Storage for default upload: **check this box**
        * ![Screenshot](../../Images/WordPress/wp-13.png)
        * Click **Save Changes**
        * From now on if you upload any Images, Audio or Video files to your WordPress site (part of your Posts or Pages), it will be uploaded to Azure Stroage account automatically instead of being stored in Web server. You can verify this once you upload any image, by going to your Storage account, Blob container.


* **Configure Redis cache for WordPress to improve performance**: You can use Microsoft Azure Redis Cache with WordPress site to improve performance. Websites that receive massive large amounts of user traffic (hundreds of thousands to millions of page views and unique visitors) will benefit from the use of a distributed caching server such as Redis cache. To setup Redis cache and connect to WordPress site
    * Create Azure [Redis cache from Azure portal](http://azure.microsoft.com/en-us/services/cache/)
    
        * ![Screenshot](../../Images/WordPress/wp-14.png)

        * After successfully creating Redis cache, note down **Host Name** & **Primary Access Key**. We will use these values in the following step
        * ![Screenshot](../../Images/WordPress/wp-16.png)


    * Install WordPress **Redis Object Cache** plugin

        * Go to WordPress site **Dashboard** page
        * Click on **Plugins**, then **Add New**
        * In the **Search plugins**, enter **Redis Object Cache**
        * Click **Install Now**
        * ![Screenshot](../../Images/WordPress/wp-15.png)
        * After installation, make sure to **Activate**

    * Connecting to Redis cache by updating **wp-config.php**
        * To edit wp-config, go to WebApp Kudu console, by selecting WebApp --> search **Kudu** --> **Advanced Tools** --> click **Go**
        * ![Screenshot](../../Images/WordPress/wp-17.png)

        * Select **Debug console**, then click **CMD**
        * ![Screenshot](../../Images/WordPress/wp-18.png)

        * In the CMD, navigate to **site\wwwroot** folder
        * Edit **wp-config.php**
        * ![Screenshot](../../Images/WordPress/wp-19.png)

        * Add the following right before **"That's all, stop editing! Happy blogging."** comment

        *define('WP_REDIS_SCHEME', 'tcp');
        define('WP_REDIS_HOST', '<your redis account name>.redis.cache.windows.net');
        define('WP_REDIS_PORT', '6379');
        define('WP_REDIS_DATABASE', '0');
        define('WP_REDIS_PASSWORD', '<your primary access key>');

        * ![Screenshot](../../Images/WordPress/wp-20.png)

        * Click **Save** on the top
    
    * Verify **Redis cache** connected
        * Go to WordPress site **Dashboard** page
        * Click on **Settings**, then **Redis**
        * Status should be: **Connected**
        * ![Screenshot](../../Images/WordPress/wp-21.png)
        
* **Other Performance Best practices**: There are only few best practices mentioned above to give an idea on how to get started. You can find additional best practices using the following resources, keep in mind you may not need all the best practices, select based on your need:
    * [How to speed up your WordPress site on Azure App Service](https://azure.microsoft.com/en-us/blog/10-ways-to-speed-up-your-wordpress-site-on-azure-websites/)
    

#### Creating a sample Post
To create a sample post, follow these steps:

* Go to WordPress site **Dashboard** page
* Click on **Posts**, then **Add New**
* Enter **Title** (Example: "FastTrack for Azure Demo post")
* In the **Content**, enter your post details
    (Exmaple: "Welcome to FastTrack for Azure Demo post. One stop shop for Azure onboarding")
* Click on **Add Media** and upload any picture file from your machine. Once the picture is uploaded, click on **Insert into post**.
* Finally click on Publish
* ![Screenshot](../../Images/WordPress/wp-22.png)

* Your post can be viewed on your home page using a link similar to this: http://fasttrackdemo.azurewebsites.net/
* ![Screenshot](../../Images/WordPress/wp-23.png)

* Now if you head over to the Storage Account in the Azure Portal, the image you uploaded part of your post can be seen under **Storage Account > Blobs > Container > Year folder > month**
* ![Screenshot](../../Images/WordPress/wp-24.png)

#### Migrating WordPress Site
To migrate WordPress site from your on-premises environment or from colo or from another Azure webapp, follow these steps:

* There are two main steps involved in migration. 1) Copying WordPress site content (wwwroot directory in Azure web app) and 2) Importing MySQL database

* **Copying WordPress site content**: Simply zip your WordPress site content from on-premises. For example if your WordPress site is running on another Azure web app, using **Kudu > CMD console**, download **wwwroot** directory as zip file. 
* ![Screenshot](../../Images/WordPress/wp-25.png)

* Next step is to import **wwwroot** directory in to Azure web app using Kudu console. To do this simply drag your content zip file (example:wwwroot.zip) from your desktop folder on to Kudu console Size column. This will extract the content in that directory.
* ![Screenshot](../../Images/WordPress/wp-26.png)

* Now export your MySQL database. You can use many tools like phpMyAdmin (web interface) or MySQL WorkBench. For example: phpMyAdmin is offered as Azure web app site **Extension**. You can install this and export your MySQL db
* ![Screenshot](../../Images/WordPress/wp-27.png)

* Next step is to import your MySQL database. Again you can use many tools phpMyAdmin (web interface) or MySQL WorkBench. From phpMyAdmin, go to Import tab, select your your MySQL file that you exported in the previous step and click Go. 
* ![Screenshot](../../Images/WordPress/wp-28.png)

* One last step, you may need to go to **wp_options** table using phpMyAdmin (web interface) or MySQL WorkBench, to replace old site url address with new site address URL.
* ![Screenshot](../../Images/WordPress/wp-29.png)

#### Optional: WordPress site with MySQL db on IaaS VM

#### Optional: Adding Custom Domain

#### Optional: Adding TLS
