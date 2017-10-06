# FastTrack for Azure - DevTest Labs IT Walkthrough

## This step by step guide will be divided into three roles:
* Owner (Can manage everything in the lab including access to resources)
* Contributor (Can manage everything like an Owner, but cannot assign access to resources)
* DevTest lab user (A lab user can view all lab resources, such as VMs, policies, and virtual networks, but cannot modify policies or VMs created by other users)

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

You can find more information about the available DevTest Labs User Roles in the [Add owners and users in Azure DevTest Labs](https://docs.microsoft.com/en-us/azure/devtest-lab/devtest-lab-add-devtest-user) documentation. Need to customize roles? Find out how to [Grant user permissions to specific lab policies](https://docs.microsoft.com/en-us/azure/devtest-lab/devtest-lab-grant-user-permissions-to-specific-lab-policies). For a broader explanation of Role Based Access Control in the Azure portal, see [Built-in roles for Azure role-based access control](https://docs.microsoft.com/en-us/azure/active-directory/role-based-access-built-in-roles).

## Governance in DevTest Labs

7. Login as the user that has "Contributor" access to DevTest labs. If you do not have an additional account available, you can continue with these steps as an owner as well.

**NOTE: Remember that the primary difference between an Owner and Contributor is that an Owner can assign access to the resource. A Contributors can only manage the resource, but cannot assign access.**

8. Navigate to your DevTest Lab.
    * Select Configuration and Policies. 
    * Select "Allowed Virtual Machine Sizes" (associated documentation [here](https://docs.microsoft.com/en-us/azure/devtest-lab/devtest-lab-configure-marketplace-images).

9. Set Enabled to On, and select a number of Virtual Machine SKUs. Save your changes prior to moving on.

![Screenshot](/Images/dtl-it-7.png)

10. Navigate to "Virtual Machines per user" (associated documentation [here](https://docs.microsoft.com/en-us/azure/devtest-lab/devtest-lab-set-lab-policy#set-virtual-machines-per-user)). 
    * Set "Limit the number of virtual machines?" to "Yes"
    * Set that limit as 2.
    * Set "Limit the number of virtual machines using premium OS disks (SSD)" to "Yes".
    * Set that limit as 0.
    * Click on the "Save" button and wait for confirmation that the changes were saved.

![Screenshot](/Images/dtl-it-8.png)

11. Navigate to "Virtual Machines per lab" (associated documentation [here](https://docs.microsoft.com/en-us/azure/devtest-lab/devtest-lab-set-lab-policy#set-virtual-machines-per-lab)). 
    * Set "Limit the number of virtual machines?" to "Yes"
    * Set that limit as 20.
    * Set "Limit the number of virtual machines using premium OS disks (SSD)" to "Yes".
    * Set that limit as 0.
    * Click on the "Save" button and verify the changes have been saved.

![Screenshot](/Images/dtl-it-9.png)

12. Navigate to "Marketplace Images" (associated documentation [here](https://docs.microsoft.com/en-us/azure/devtest-lab/devtest-lab-configure-marketplace-images).
    * Set "Allow all Azure Marketplace images as virtual machine bases" to "No".
    * You may have a set of internal business rules on those operating systems that may be used.
    * For demo purposes, we have selected Red Hat Enterprise Linux 7.2, 7.3, Windows Server 2016 Datacenter and Visual Studio 2017 images.
    * Click on the "Save" button and verify that the changes have been saved. 

![Screenshot](/Images/dtl-it-95.png)

## Cost Control

13. Navigate to "Configurations and Policies" in your DevTest lab. 
    * Select Cost Trend
    * Select Manage Target

![Screenshot](/Images/dtl-it-10.png)

14. Select Monthly Time Period, and enter a relevant target cost.
    * Select one of the % options in the resulting table.
    * In the blade that appears, ensure that both "Notification" and "Display on Chart" are set to "On".
    * Click "OK" to save the changes.

![Screenshot](/Images/dtl-it-11.png)

15. Once you have configured your cost notifications, click on "Click here to add an integration". 
    * Notice that you can use a Webhook for notification purposes.
    * We will not enter anything in this blade. Click on the "X" to exit this blade and then select "OK" on the primary blade.
![Screenshot](/Images/dtl-it-12.png)

16. You will notice that there are now horizontal lines denoting the limits that you have enabled. For further information on cost management, see the associated documentation on [the monthly estimated lab cost trend in Azure DevTest Labs](https://docs.microsoft.com/en-us/azure/devtest-lab/devtest-lab-configure-cost-management#viewing-the-monthly-estimated-cost-trend-chart).

![Screenshot](/Images/dtl-it-13.png)

17. Select "Cost by resource" from the left hand menu of the "Configuration and Policies" blade.
    * This page will give you a break down of the cost of the resources contained within your DevTest Lab environment.

![Screenshot](/Images/dtl-it-14.png)

18. Select "Auto-shutdown" from the left hand menu of the "Configuration and Policies" blade (associated documentation [here](https://docs.microsoft.com/en-us/azure/devtest-lab/devtest-lab-set-lab-policy#set-auto-shutdown).
    * Set "Enabled" to "On".
    * Set "Scheduled Shutdown to 5:30:00 PM.
    * Notice that you can once again be notified of this, and use a webhook for this purpose.
    * Click on "Save" for the changes to take effect.

![Screenshot](/Images/dtl-it-15.png)

19. Select "Auto-start" from the left hand menu of the "Configuration and Policies" blade (associated documentation [here](https://docs.microsoft.com/en-us/azure/devtest-lab/devtest-lab-set-lab-policy#set-auto-start).
    * Set "Allow virtual machines to be scheduled for automatic start" to On.
    * Set "Scheduled start" to 8:30:00 AM.
    * Select which days of the week you would like the machines to start automatically. 
    * Notice that you can once again be notified of this, and use a webhook for this purpose.
    * Click on "Save" and validate that the changes have been saved.

![Screenshot](/Images/dtl-it-16.png)

## Setting up your Lab environment

20. Navigate to "My Secrets" on your DevTest Lab blade.

![Screenshot](/Images/dtl-it-17.png)

21. On the resulting blade
    * Enter a name for your secret. 
    * Enter the value of your secret.
    * This could be either a password, or SSHKey. This is stored in Azure KeyVault, and has a personal secret store for each user.
    * Click on "Save" and validate that the changes have been saved.

![Screenshot](/Images/dtl-it-18.png)

22. Navigate to Formulas (reusable bases) on the left hand menu of your DevTest Lab blade (associated documentation [here](https://docs.microsoft.com/en-us/azure/devtest-lab/devtest-lab-manage-formulas))..
    * Click on "Add".
    * Select RedHat Enterprise Linux 7.3.
    * Enter a representative name and description for the Formula.
    * Notice that the premium disk "SSD" can be selected, but if the Formula is deployed with this option enabled there will be a warning message blocking the deployment based on the lab setup. 
    * Select only the standard disk "HDD" option to avoid an error during deployment of the Formula.

![Screenshot](/Images/dtl-it-19.png)

23. Click on Artifacts (associated documentation available [here](https://docs.microsoft.com/en-us/azure/devtest-lab/devtest-lab-artifact-author)).
    * Select Docker.
    * Click Add.
    * Click OK.

![Screenshot](/Images/dtl-it-20.png)

24. Select advanced settings in the Create formula (reusable base) blade.
    * Note that the IP Address configuration is set to shared. This means that the lab will share an IP Address across Virtual Machines, and give each VM a different port. This is dealt on your behalf by the DevTest lab service. It is worth familiarising yourself with the documentation to [Understand shared IP addresses in Azure DevTest Labs](https://docs.microsoft.com/en-us/azure/devtest-lab/devtest-lab-shared-ip)
    * Set "Make this machine claimable" to "Yes". A claimable machine is a type of Virtual Machine that is available as part of a pool, and not associated with a specific user. There is further documentation available on how to [add a claimable VM to a lab in Azure DevTest Labs](https://docs.microsoft.com/en-us/azure/devtest-lab/devtest-lab-add-claimable-vm)
    * Set "Number of Instances" to 2.
    * Accept the changes and create the Formula.

![Screenshot](/Images/dtl-it-21.png)

25. Navigate to "Configurations and Policies" in the left hand menu of your DevTest lab blade. 
    * Select Repositories from the left hand menu of the Configuration and policies blade. Repositories allow you to use custom artifacts as part of your Virtual Machine setup steps, and deploy ARM Templates as environments within DevTest labs. More information is available on how to [add a Git repository to store custom artifacts and Resource Manager templates](https://docs.microsoft.com/en-us/azure/devtest-lab/devtest-lab-add-artifact-repo). 
    * Click Add.

![Screenshot](/Images/dtl-it-22.png)

26. Complete the details of the form to allow a Git repository to act as a source of Artifacts and Templates for your DevTest Lab.
    * Follow the "Creating a token" section of [this guide](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/#creating-a-token) if you need to create a Personal Access Token for GitHub.
    * Alternatively, follow the [Authenticate access with personal access tokens for VSTS and TFS](https://docs.microsoft.com/en-us/vsts/accounts/use-personal-access-tokens-to-authenticate) documentation if you plan to use Visual Studio Team Services.
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

29. From the Overview section of your DevTest Lab, click "Add" at the top of the page, to create a Virtual Machine based from an allowed marketplace image.
    * Select a Windows based image.
    * Use the password that you have stored in "My Secrets".
    * Add the Azure PowerShell, Docker, Git and Visual Studio Code artifacts to the machine.

![Screenshot](/Images/dtl-it-26.png)

30. Your Virtual Machines will then be provisioned. After a short period of time, click on your Windows-based Virtual Machine in "My Machines".

![Screenshot](/Images/dtl-it-27.png)

31. Click "Create custom image" on your Virtual Machine blade. Further documentation is available [here](https://docs.microsoft.com/en-us/azure/devtest-lab/devtest-lab-create-custom-image-from-vm-using-portal). You will also notice that there are a number of options to create custom images based on existing VHD images.
    * Enter a representative name and description for your image. This name will be presented in the view when any DevTest labs user creates a new Virtual Machine.
    * If you have not performed a sysprep on the Virtual Machine, then:
        * Set "I have run Sysrep on the Virtual Machine" to "No".
        * Set "Run sysprep on virtual machine" to "Yes".
    * If you have performed a sysprep on the Virtual MAchine, then: 
        * Set "I have run Sysrep on the Virtual Machine" to "Yes".
        * Set "Run sysprep on virtual machine" to "No".

![Screenshot](/Images/dtl-it-28.png)

# Next Steps
Progress to the [developer walkthrough](https://github.com/Azure/onboarding-guidance/blob/master/DevTest/DevTestLabs/2%20-%20devtest-labs-walkthrough-dev.md), which details the features of DevTest Labs from a DevTest Labs user perspective.

# Additional Documentation
* You can add existing Virtual Networks to your DevTest Lab and configure a number of options. For example, what type of IP addresses are allowed, which subnets are allowed for Virtual Machine creation and more. Find out how to [configure a virtual network in Azure DevTest Labs](https://docs.microsoft.com/en-us/azure/devtest-lab/devtest-lab-create-custom-image-from-vm-using-portal).
* What if you want to replicate a whole environment in DevTest labs? Or leverage PaaS resources? Find out how to [create multi-VM environments and PaaS resources with Azure Resource Manager templates](https://docs.microsoft.com/en-us/azure/devtest-lab/devtest-lab-create-environment-from-arm)
* Reaching the quota limits that have been set on your subscription? Find out about [Scale quotas and limits in DevTest Labs](https://docs.microsoft.com/en-us/azure/devtest-lab/devtest-lab-scale-lab)
 
