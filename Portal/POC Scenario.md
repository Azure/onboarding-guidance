# POC Scenario: Deploying Website on Azure IaaS VMs

# Abstract

During this module, you will learn about bringing together all the infrastructure components to build a sample application and making it scalable, highly available and secure.

# Learning objectives
After completing the exercises in this module, you will be able to:
* Create a Resource Group
* Create a Virtual Network
* Create multiple virtual machines
* Create and setup a load balancer
* Create an availability set for VMs
* Update Network Security Groups(NSG)
* Deploy a website

# Prerequisite 
* [Basic Setup Introduction](https://github.com/Azure/onboarding-guidance/blob/master/windows/Module%200/L2-SetupIntro.md)
* [Storage Introduction](https://github.com/Azure/onboarding-guidance/blob/master/windows/Module%20I/L1-StorageIntro.md)
* [Compute Introduction](https://github.com/Azure/onboarding-guidance/blob/master/windows/Module%20II/L1-ComputeIntro.md)

# Estimated time to complete this module:
Self-guided

# Customize your Azure Portal
* Launch [Azure Portal](http://www.azure.portal.com)
* On left most panel, scroll to bottom, then click **More Services**
* Find and Pin, **Virtual Network**
* Find and Pin, **Availability Set**
* Find and Pin, **Load Balancer**
* Find and Pin, **Network Security Group**

# Resource Group creation
  > Note: For all **(prefix)** references, use a globally unique name to be used throughout this walkthrough.

  * Create Resource Group - **(prefix)**-poc-rg

# Virtual Network Creation
  * Create a VNET named **(prefix)**-vnet-usw1
  * Create a Web Subnet named **(prefix)**-web-snet
  * Create a App Subnet named **(prefix)**-app-snet

# Virtual Machine Creation
  * Create 2 VMs
  * Select from the marketplace, **Windows Server 2012 R2 Datacenter**
  * Name the 1st VM **(prefix)**-web01-vm
  * Name the 2nd VM **(prefix)**-web02-vm
  * Make sure to choose **HDD disk**
  * For the size select **F1S**
  * Create Storage account - **(prefix)**web01vmst01
  * Create Storage account - **(prefix)**web02vmst01
  * Create availability set - **(prefix)**-as-web
  > Note: During 2nd VM creation pick the previously created Availability set
  * Create Diagnostics Storage account named **(prefix)**webdiag

# Install IIs on VMs
  * From Virtual Machine blade, select 1st VM, click **Connect** and login to machine
  * From the **Server Manager Dashboard**, select **Add Roles and Features**
  * Click **Next** on **Before you Begin**
  * Click **Next** on **Installation Type**
  * Click **Next** on **Server Selection**
  * On **Server Roles**, select **IIS**, click **Next**
  * Click **Next** and accept all the defaults to finish Installation
  * From the **Start** menu, type **IIS**, and Launch
  * In the **Connections** panel, **Right-Click** on **Default Web Site**, and select **Switch to Content View**
  * **Right-Click** anywhere in panel and selct **Explore**
  * From the **Windows Explorer**, **Right-Click** on the file **IISStart.html**, and open in Notepad.
  * Find the follow line right after the **body** tag. 
```
For VM1: <h1>This is Web Server 01</h1>
For VM2: <h1>This is Web Server 02</h1>
```
  * From Virtual Machine blade, select 2nd VM, click **Connect** and login to machine and repeat all the steps above.

# Create Load Balancer
  * From the left panel on the Azure Portal, select **Load Balancers**.
  * Click on **Add**
  * Name: **(prefix)**-web-lb
  * Click **Public IP Address**, click **New**
  * Enter name **(prefix)**-web-pip, set assignment to **Static**, click **Ok**
  * Select **Use Existing** for **Resource Group**, i.e. **(prefix)**-poc-rg, click **Create**
  * Under **Settings** select **Probes**, click **Add**.
  * Enter name **(prefix)**-web-prob, click **Ok**

# Add the VMs to Load Balancer
  * Under **Settings** select **Backend pools**, click **Add**.
  * Enter name **(prefix)**-web-pool.
  * Select **Availability set**, click **(prefix)**-web-as.
  * Click **Add a virtual machine**, click **Select** and check **both** VMs, click **Ok**

  * Under **Settings** select **Load balancing rules**, click **Add**.
  * Enter name **(prefix)**--http-lbr
    *  Protocol: **TCP**
    *  Port:**80**
    *  Backend port: 80
    *  Backend pool: **(prefix)**-web-pool(2VMs)
    *  Probe: **(prefix)**-web-prob(HTTP:80)
    *  Session Persistence: **None**
    *  Idle timeout (min):**4**

# Update the NSG (inbound security rule)
## Virtual machine #1
  * From the left panel on the Azure Portal, select **Virtual machines**, then select **(prefix)**-web01-vm.
  * Under **Settings** select **Network Interfaces** 
  * Click on **(prefix)**-web01-vm-nsg.
  * Under **Settings** select **Network Security Groups**.
  * Click on **(prefix)**-web01-vm-nsg.
  * Under **Settings**, click on **Inbound Security Rules**.
  * Click **Add**, Enter name **(prefix)**-web01-vm-nsgr-http-allow
    *  Priority:**1010**
    *  Source: **any**
    *  Service: **HTTP**
    *  Protocol: **TCP**
    *  Port range: **80**
    *  Action: **Allow**

## Virtual machine #2
  * From the left panel on the Azure Portal, select **Virtual machines*, then select **(prefix)**-web02-vm.
  * Under **Settings** select **Network Interfaces** 
  * Click on **(prefix)**-web02-vm-nsg.
  * Under **Settings** select **Network Security Groups**.
  * Click on **(prefix)**-web02-vm-nsg.
  * Under **Settings**, click on **Inbound Security Rules**.
  * Click **Add**, Enter name **(prefix)**-web02-vm-nsgr-http-allow
    *  Priority:**1010**
    *  Source: **any**
    *  Service: **HTTP**
    *  Protocol: **TCP**
    *  Port range: **80**
    *  Action: **Allow**

# Assign DNS name to Load Balancer
  * From the left panel on the Azure Portal, select **Load Balancers**.
  * Select **(prefix)**-web-lb.
  * Click on **Overview**.
  * Click **Public IP Address**
  * Select **Configuration**
  * Under **Settings**, select **Configuration**. 
  * Under DSN name enter **(prefix)**.
      * i.e. http://**(prefix)**.westus.cloudapp.azure.com/

# Testing 
  * Browse to load balancer public IP (or) http://**(prefix)**.westus.cloudapp.azure.com/
  * You will see IIS server default page, with either VM1 or VM2.
  * If you see VM1, then RDP1 into VM1, stop Default Web Site in IIS. Refresh web page, you will see VM2. Load balancer detects VM1 is down and redirects traffic to VM2.

# Automation Scripts (ARM Template)
  * From the left panel on the Azure Portal, select **Resource Groups**.
  * Select **(prefix)**-poc-rg.
  * Click **Download** | **Save As** | (select location)
  * After download, **Extract All** to (select location)
  * Visulize your Architecture with **ArmViz**
  * Open browser and goto **http://armviz.io** to view the template.

   ![Screenshot](./images/ArmVizDiagram.png)

