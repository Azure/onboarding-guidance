# Fast Track for Azure Dev Test Solution - VSTS Walkthrough

This folder is work in progress, please stay tuned! 

# Abstract

During this module, you will learn about Visual Studio Team System (VSTS) and setting it up for DevOps.  VSTS is an extension of the Microsoft Visual Studio architecture that allows it to encompass development teams, with special roles and tools for software architects, developer specialties and testers.

# Learning objectives
After completing the exercises in this module, you will be able to:
* Login & Basic Navigation
* Code Files, History, and Pulls Requests
* Workitems and backlogs
* Settign up a Build definition
* Setting up a Release definition & plan
* Setting up a Manual Test & Load Test plan
* Overview of tracking sprints, building, and releasing applications.

## Pre-Requisites
* To complete this PoC, you will need:
    * Visual Studio Team Services account. If you don’t have one, you can create from [here](https://www.visualstudio.com/)
    * Visual Studio 2015 or higher version
    * You can use the [VSTS Demo Data generator](http://vstsdemogenerator.azurewebsites.net/Environment/Create) to provision a project with pre-defined data on to your Visual Studio Team Services account.
    * During this lab, we are using the Contoso Expenses application for the hands-on-labs.

# Estimated time to complete this module:
Self-guided

# DevOps Overview
* DevOps is the union of People, Process and our Products to enable continuous delivery of value to your end users. In todays world, the speed of business is so rediculously fast that this DevOps mindset, continously delivering value to your end user, is absolutely vital. If you have not adopted this mindset, your competitors either have or will and they will quickly out innovate you and render you obsolete. Microsoft has the products and services that easily enables full end to end DevOps coverage. That product is Visual Studio Team Services. VSTS provides full DevOps coverage with the following:
    * Agile Planning/Work Item Tracking. VSTS has the ability to track any unit of work in an agile fashion for a software project. This includes things like, bugs, user stories,impediments etc.
    * Source Control. VSTS has 2 source control systems. A centralized version control system and a distributed version control system. The distributed version control system is git. Not some weird microsoft only version of git, but just the open source version of git, implemented in VSTS.
    * Build (Continuous Integration). A automated build system that can be easily customized to do anything. This build system can build any language on any platform
    * Test. VSTS has a full end to end testing platform from unit testing, to manual testing, to automated testing, to load testing.
    * Deploy (Continuous Delivery). VSTS has a fully customizable deployment system that can take your binaries and deploy them onto anything, anywhere.
    * Feedback loop with Application Insights.

* Visual Studio Team Services is everything you need to build software.

# Key Takeaways
  * Microsoft has products and services that give you full end to end DevOps coverage. Visual Studio Team Services. VSTS is everything you need to build software in any language for any platform.
  * You can build out your CI/CD pipelines easily and make them do just about anything.

  ![Screenshot](/Images/VSTS-Pic-1.png)

# Login
* How to login to VSTS.
    * [Sign into your Visual Studio Team Services Account](https://www.visualstudio.com/team-services/)
    * If you don't have one already, Click <**Getting Started for Free**>

# Basic Navigation
* A quick tour of VSTS

  ![Screenshot](/Images/VSTS-Pic-2.png)

# VSTS Home Page
This is the home page for ALL your projects. You can select yours here. e.g **FTAPOC**
  ![Screenshot](/Images/VSTS-Pic-2.png)

# Dashboard, project activity
Once you make a selection, you will be on the project home page. Here you can see the current activity, manage your work, collaborate on code, setup continuous integration and deployments, and visualize your progress.
  ![Screenshot](/Images/VSTS-Pic-3.png)

# Code Files
Team Services supports two types of version control Git and Team Foundation Version Control (TFVC). Here is a quick overview of the two version control systems:

* Team Foundation Version Control (TFVC): TFVC is a centralized version control system. Typically, team members have only one version of each file on their dev machines. Historical data is maintained only on the server. Branches are path-based and created on the server.
* Git: Git is a distributed version control system. Git repositories can live locally (such as on a developer’s machine). Each developer has a copy of the source repository on their dev machine. Developers can commit each set of changes on their dev machine and perform version control operations such as history and compare without a network connection.

Git is the default version control provider for new projects. You should use Git for version control in your projects unless you have a specific need for centralized version control features in TFVC.

  ![Screenshot](/Images/VSTS-Pic-99.png)

## Files

## History

## Pull Requests

# Work
* In this section you will learn about the agile planning and portfolio management tools and processes provided by Visual Studio Team Services and how they can help you quickly plan, manage, and track work across your entire team.

  ![Screenshot](/Images/VSTS-Pic-99.png)

## Backlogs

# Build & Release
* How to create a build & release definition to provide the continous integration(CI) and continous deployment (CD) pipeline.

## Build Definition
* How to create a build definition to provide ...

## Release Definition
* How to create a release definition to provide ...

## Release Plans
* How to create a release plan to provide ...

# Setting up a Release

# Tests
* Here is where you can manage your project test lifecycle using the Visual Studio Team Services.

  ![Screenshot](/Images/VSTS-Pic-99.png)

## Test Plans
* You can create test plans designed efficiently to validate your software milestones. You will also be able to create and execute manual tests that can be consistently reproduced over the course of each release.

## Load Tests
* Load Testing allow you to stress the application and review how it behaves under diferent load of users so we can take actions on the current infrastructure adding more capacities for the times we think we will need it. 

## Useful References
* [Visual Studio Team Services, Getting Started](https://www.visualstudio.com/)
* [Visual Studio Team Services, Product Updates](https://www.visualstudio.com/team-services/updates/)
* [Visual Studio Team Services, Support](https://www.visualstudio.com/team-services/support/)
