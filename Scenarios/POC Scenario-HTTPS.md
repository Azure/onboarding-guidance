# POC Scenario 1: Deploying Website on Azure IaaS VMs - HTTPS

# Abstract
To deploy website using HTTPS, complete the steps first from [HTTP scenario](https://github.com/Azure/onboarding-guidance/blob/master/Portal/POC%20Scenario-HTTP.md), once that done, proceed to the steps mentioend below.
Steps mentioned below only covers configuration needed on Azure side, it doesn't cover the steps that are needed to procure and install certificate on the VMs. These steps are beyond the scope of this document, and its exactly same as doing it in on-premises VMs. 

# Learning objectives
After completing the exercises in this module, you will be able to:
* Run HTTPS site on Azure IaaS VMs


# Prerequisite 
* [Deploying Website on Azure IaaS VMs - HTTP](https://github.com/Azure/onboarding-guidance/blob/master/Portal/POC%20Scenario-HTTP.md)

# Estimated time to complete this module:
Self-guided.

# Install Certificate on VMs
Procure (or use self signed certificate for testing purpose only) SSL certificate, import/configure on both VMs IIS. Thse steps are beyond the scope of this document, and its exactly same as doing it in on-premises VMs. 

To perform these steps, Login to VMs 

  * From Virtual Machine blade, select the 1st VM, click **Connect** and login to machine

   ![Screenshot](/Images/POC-9.png)


# Create Load Balancing Rule for HTTPS
  * Select the **Load Balancer** 

     ![Screenshot](/Images/POC-17.png)

  * Under **Settings** select **Load balancing rules**, click **Add**.
  * Enter name **(prefix)-https-lbr**.
    *  Protocol: **TCP**
    *  Port:**443**
    *  Backend port: 443
    *  Backend pool: **(prefix)-web-pool(2VMs)**
    *  Probe: **(prefix)-web-prob(HTTP:80)**
    *  Session Persistence: **None**
    *  Idle timeout (min):**4**
    *  Floating IP (direct server return): **Disabled**
    *  Click **Ok**

   ![Screenshot](/Images/POC-31.png)

# Update the NSG (inbound security rule)
Following steps will add inbound security rule to allow HTTPS traffic to VM1 & VM2

## Virtual machine #1
  * From the left panel on the Azure Portal, select **Virtual machines**, then select **(prefix)-web01-vm**.
  * Under **Settings** select **Network Interfaces** 
  * Click on **(prefix)-web01-vm-nsg**.
  * Under **Settings** select **Network Security Groups**.
  * Under **Network Security Group**, click on **(prefix)-web01-vm-nsg**.

   ![Screenshot](/Images/POC-23.png)
 

 * Under **Settings**, click on **Inbound Security Rules**.
  * Click **Add**, Enter name **(prefix)-web01-vm-nsgr-https-allow**
    *  Priority:**1030**
    *  Source: **any**
    *  Service: **HTTPS**
    *  Protocol: **TCP**
    *  Port range: **443**
    *  Action: **Allow**

   ![Screenshot](/Images/POC-32.png)


## Virtual machine #2

  * From the left panel on the Azure Portal, select **Virtual machines**, then select **(prefix)-web02-vm**.
  * Under **Settings** select **Network Interfaces** 
  * Click on **(prefix)-web02-vm-nsg**.
  * Under **Settings** select **Network Security Groups**.

  ![Screenshot](/Images/POC-25.png)

 * Under **Settings**, click on **Inbound Security Rules**.
  * Click **Add**, Enter name **(prefix)-web02-vm-nsgr-https-allow**
    *  Priority:**1020**
    *  Source: **any**
    *  Service: **HTTPS**
    *  Protocol: **TCP**
    *  Port range: **443**
    *  Action: **Allow**

   ![Screenshot](/Images/POC-33.png)

# Testing 
  * Browse to load balancer public IP (or) **https://(prefix).westus2.cloudapp.azure.com/**
  * You will see IIS server default page, with either VM1 or VM2.
  * If you see VM1, then RDP1 into VM1, stop Default Web Site in IIS. Refresh web page, you will see VM2. Load balancer detects VM1 is down and redirects traffic to VM2.

   ![Screenshot](/Images/POC-34.png)
