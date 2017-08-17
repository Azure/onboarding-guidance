# FastTrack for Azure - DevTest Labs IT Walkthrough

## This step by step guide will be divided into three roles:
* Owner (Can perform all task performed by Contributor )
* Contributor 
* DevTest lab user (Covered in a [separate article](devtest-labs-walkthrough-dev.md))

## Initial Setup
1. Navigate to DevTest Labs in the Azure Portal.

![Screenshot](/Images/dtl-it-1.png)

2. Create a Dev Test Lab using your naming convention. You will notice that you have an option to enable Auto-Shutdown during the creation process. We will select Enabled to "No" for this option.

![Screenshot](/Images/dtl-it-2.png)

**NOTE: We have used fta-delta-dev-dtl. This follows a format of &lt;Organisation&gt;-&lt;Project&gt;-&lt;Environment&gt;-&lt;Resource&gt;.**

3. Once the deployment has completed, you will find five newly created resources:
    * A Resource Group
    * A Storage Account
    * A Virtual Network
    * A DevTest Lab
    * A KeyVault

![Screenshot](/Images/dtl-it-3.png)

4. Navigate to the configuration and policies section under your DevTest lab resource.

![Screenshot](/Images/dtl-it-4.png)

5. Select Access Control (IAM). Click on "Add" at the top of the new blade.

![Screenshot](/Images/dtl-it-5.png)

6. Add a user as a "Contributor" to your DevTest labs. Secondly, add another user as a "DevTest Labs User".

![Screenshot](/Images/dtl-it-6.png)

## Governance in DevTest Labs

7. Login as the user that has "Contributor" access to DevTest labs. If you do not have an additional account available, you can continue with these steps as an owner as well.

**NOTE: Remember that the primary difference between an Owner and Contributor is that an Owner can assign access to the resource. Both Owners and Contributors can manage the resource.**

8. Navigate to your DevTest Lab.
    * Select Confguration and Policies. 
    * Select "Allowed Virtual Machine Sizes".

9. Set Enabled to On, and select a number of Virtual Machine SKUs. Save your changes prior to moving on.

![Screenshot](/Images/dtl-it-7.png)

10. Navigate to "Virtual Machines per User". 
    * Set "Limit the number of virtual machines?" to "Yes"
    * Set that limit as 2.
    * Set "Limit the number of virtual machines using premium OS disks (SSD)" to "Yes".
    * Set that limit as 0.

![Screenshot](/Images/dtl-it-8.png)

11. Navigate to "Virtual Machines per User". 
    * Set "Limit the number of virtual machines?" to "Yes"
    * Set that limit as 20.
    * Set "Limit the number of virtual machines using premium OS disks (SSD)" to "Yes".
    * Set that limit as 0.

![Screenshot](/Images/dtl-it-9.png)

12. Navigate to "Marketplace Images".
    * Set "Allow all Azure Marketplace images as virtual machine bases" to "No".
    * You may have a set of internal business rules on those operating systems that may be used.
    * For demo purposes, we have selected Red Hat Enterprise Linux 7.2, 7.3, Windows Server 2016 and Visual Studio 2017 images.

![Screenshot](/Images/dtl-it-95.png)

## Cost Control

13. Navigate to "Configurations and Policies" in your DevTest lab. 
    * Select Cost Overview
    * Select Cost Trend
    * Select Manage Target

![Screenshot](/Images/dtl-it-10.png)

14. Select Monthly Time Period, and enter a relevant target cost.
    * Select one of the %s in the table below.
    * In the resulting blade, ensure that both "Notification" and "Display on Chart" are set to "On".

![Screenshot](/Images/dtl-it-11.png)

15. Once you have configured your cost notifications as desired, click on "Click here to add an integration". 
    * Notice that you can use a Webhook for notification purposes.
    * We will not enter anything in this blade. Click Ok and select Ok on the manage target blade.
![Screenshot](/Images/dtl-it-12.png)

16. You will notice that there are now horizontal lines denoting the limits that you have enabled.

![Screenshot](/Images/dtl-it-13.png)

17. Select "Cost by resource" from the left hand menu.
    * This page will give you a break down of the cost of the resources contained within your DevTest lab environment.

![Screenshot](/Images/dtl-it-14.png)

18. Select "Auto-shutdown" from the left hand menu.
    * Set "Enabled" to "On".
    * Set "Scheduled Shutdown to 5:30:00 PM.
    * Notice that you can once again be notified of this, and use a webhook for this purpose.
    * Click Save.

![Screenshot](/Images/dtl-it-15.png)

19. Select "Auto-start" from the left hand menu.
    * Set "Allow virtual machines to be scheduled for automatic start" to On.
    * Set "Scheduled start" to 8:30:00 AM.
    * Notice that you can once again be notified of this, and use a webhook for this purpose.
    * Click Save.

![Screenshot](/Images/dtl-it-16.png)

## Setting up your Lab environment

20. Navigate to "My Secrets" on your DevTest Lab blade.

![Screenshot](/Images/dtl-it-17.png)

21. On the resulting blade
    * Enter a name for your secret 
    * Enter the value of your secret
    * This could be either a password, or SSHKey. This is stored in Azure KeyVault, and has a personal secret store for each user.

![Screenshot](/Images/dtl-it-18.png)

22. Navigate to Formulas (reusable bases) on your DevTest Lab blade.
    * Select RedHat Enterprise Linux 7.3.
    * Enter a representative name and description
    * Notice that the premium option is disabled, due to the options that were selected during the lab setup process.
    * Notice that the disk options available are also limited to those that were selected during the lab setup process.

![Screenshot](/Images/dtl-it-19.png)

23. Click on Artifacts.
    * Select Docker.
    * Click Add.

![Screenshot](/Images/dtl-it-20.png)

24. Select advanced settings in the Create formula (reusable base) blade.
    * Note that the IP Address configuration is set to shared. This means that the lab will share an IP Address across Virtual Machines, and give each VM a different port. This is dealt on your behalf by the DevTest lab service.
    * Set "Make this machine claimable" to "Yes".
    * Set "Number of Instances" to 2.
    * Accept the changes and create the formula.

![Screenshot](/Images/dtl-it-21.png)

25. Navigate to "Configurations and Policies" in your DevTest lab. 
    * Select Repositories from the left hand menu of the Configuration and policies blade.
    * Click Add.

![Screenshot](/Images/dtl-it-22.png)

26. Complete the details of the form to allow a Git repository to act as a source of Artifacts and Templates for your DevTest Lab.
    * Find out more about [adding a Git repository to store custom artifacts and Azure Resource Manager templates for use in Azure DevTest Labs](https://docs.microsoft.com/en-us/azure/devtest-lab/devtest-lab-add-artifact-repo)
    * Follow the "Creating a token" section of [this guide](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/#creating-a-token) if you need to create a Personal Access Token for GitHub.
    * Be careful with the folder path to your Artifact or Template directories. For example, you can see that /Artifacts/ is correct, whereas /master/Tree/Artifacts/ would not be correct.

![Screenshot](/Images/dtl-it-23.png)

27. Submit the form once you have entered your Personal Access Token. An attempt will be made to connect to the repository using the provided details.

![Screenshot](/Images/dtl-it-24.png)

28. Navigate to the Overview section of your DevTest Lab.
    * Click "Add" at the top of the page, to create an environment, VMs based from allowed marketplace images or VMs based from custom images.
    * Select the formula that you had created earlier.
    * Provide a suitable Virtual Machine name.


* This step has begun provisioning a number of claimable Virtual Machines that any lab user could claim for their own use. This could be useful in an environment where nightly builds are created, and shipped on custom images. This would allow testers to have a pool of Virtual Machines that contain the latest build, and can be claimed for testing purposes.

![Screenshot](/Images/dtl-it-25.png)

29. From the Overview section of your DevTest Lab, click "Add" at the top of the page, to create a Virtual MAchine based from an allowed marketplace image.
    * Select a Windows based image.
    * Use the password that you have stored in "My Secrets".
    * Add the Azure PowerShell, Docker, Git and Visual Studio Code artifacts to the machine.

![Screenshot](/Images/dtl-it-26.png)

30. Your Virtual Machines will then be provisioned. After a short period of time, click on your Windows-based Virtual Machine in "My Machines".

![Screenshot](/Images/dtl-it-27.png)

31. Click "Create custom image" on your Virtual Machine blade.
    * Enter a representative name and description for your image. This name will be presented in the view when any DevTest labs user creates a new Virtual Machine.
    * If you have not performed a sysprep on the Virtual Machine, then:
        * Set "I have run Sysrep on the Virtual Machine" to "No".
        * Set "Run sysprep on virtual machine" to "Yes".
    * If you have performed a sysprep on the Virtual MAchine, then: 
        * Set "I have run Sysrep on the Virtual Machine" to "Yes".
        * Set "Run sysprep on virtual machine" to "No".

![Screenshot](/Images/dtl-it-28.png)

# Next Steps
Progress to the [developer walkthrough](devtest-labs-walkthrough-dev.md), which details the features of DevTest Labs from a DevTest Labs user perspective.
