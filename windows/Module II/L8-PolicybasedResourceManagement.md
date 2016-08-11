# Module:- Use Policy to manage resources and control access 

# Abstract
During this module, you will learn how to use policy to manage resources and control access.

# Learning objectives
After completing the exercises in this module, you will be able to:
* Understand the basic structure of the policy definition language
* How you can apply these policies at different scopes
* See some examples of how you can achieve this through REST API

# Prerequisite 
* Completion of [Module on Storage](https://#)

# Estimated time to complete this module:
30 min

# How do I use Policy to manage resources and control access?
Azure Resource Manager now allows you to control access through custom policies. With policies, you can prevent users in your organization from breaking conventions that are needed to manage your organization's resources.
You create policy definitions that describe the actions or resources that are specifically denied. You assign those policy definitions at the desired scope, such as the subscription, resource group, or an individual resource.

# How is it different from RBAC?
There are a few key differences between policy and role-based access control, but the first thing to understand is that policies and RBAC work together. To be able to use policy, the user must be authenticated through RBAC. Unlike RBAC, policy is a default allow and explicit deny system. 

# See the following resources to learn more
* [Use Policy to manage resources and control access]( https://azure.microsoft.com/en-us/documentation/articles/resource-manager-policy/)
