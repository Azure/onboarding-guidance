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
* Setting up a Release definition
* Setting up a Manual Tests & Load Tests
* Tracking sprints, builds, releases, and tests.

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

  ![Screenshot](/Images/VSTS-Pic-4.png)

## Files
  ![Screenshot](/Images/VSTS-Pic-5.png)

## History
  ![Screenshot](/Images/VSTS-Pic-6.png)

## Pull Requests
* Create pull requests to review and merge code in a Git team project. Pull requests let your team give feedback on changes in feature branches before merging the code into the master branch. Reviewers can step through the proposed changes, leave comments, and vote to approve or reject the code.

# Work
* In this section you will learn about the agile planning and portfolio management tools and processes provided by Visual Studio Team Services and how they can help you quickly plan, manage, and track work across your entire team.

  ![Screenshot](/Images/VSTS-Pic-7.png)

## Backlogs
* Your product backlog corresponds to your project plan, the roadmap for what your team plans to deliver. Once defined, you have a prioritized list of features and requirements to build. Your backlog also provides a repository of all the information you need to track and share with your team.

# Build & Release
* How to create a build & release definition to provide the continous integration(CI) and continous deployment (CD) pipeline.

* CI means starting an automated build (and possibly running tests) whenever new code is committed to or checked into the team project's source control repository. This gives you immediate feedback that the code builds and can potentially be deployed. 
* CD means starting an automated deployment process whenever a new successful build is available. Together, CI and CD mean that any code changes you commit to your repository are quickly validated and deployed to a test server, a live web site, or wherever you need it.

  ![Screenshot](/Images/VSTS-Pic-9.png)

## Build Definition
* Create a build definition to define how code gets compiled.

  ![Screenshot](/Images/VSTS-Pic-10.png)

* A build definition is the entity through which you define your automated build process. In the build definition, you compose a set of tasks, each of which perform a step in your build.

* Choose a template that builds your kind of app.

  ![Screenshot](/Images/VSTS-Pic-11.png)

* The task catalog provides a rich set of tasks for you to get started. You can also add Powershell or shell scripts to your build definition.

  ![Screenshot](/Images/VSTS-Pic-12.png)

* Continuous Integration to build every change to matching branches. A continuous integration trigger on a build definition indicates that the system should automatically queue a new build whenever a code change is committed. You can make the trigger more general or more specific, and also schedule your build (for example, on a nightly basis). 

  ![Screenshot](/Images/VSTS-Pic-13.png)

* Scheduled a build matching branches for each schedule.

  ![Screenshot](/Images/VSTS-Pic-14.png)

* Save and queue a build manually to test a build definition.

  ![Screenshot](/Images/VSTS-Pic-15.png)

* You can view a summary of all the builds or drill into the logs for each build at any time by navigating to the Builds tab in the Build & Release hub. For each build, you can also view a list of commits that were built and the work items associated with each commit. You can also run tests in each build and analyze the test failures.

  ![Screenshot](/Images/VSTS-Pic-16.png)

* Once the build finishes, you can see the build report. In this build report, you see all the build issues, you see the changesets that were build, the associated work items, the unit tests that were run as well as the code coverage and even where this build got release to.

  > The build system is basically a glorified task runner where it does one task, after another, after another. Out of the box, VSTS comes with a huge set of tasks that it can do. If you need your build to do something that doesn't exist out of the box, you can Go to the Marketplace where the community has created a library of tasks. If what you want to do doesn't exist in the Marketplace, you can easily create your own custom task. A custom task is nothing more than either powershell or node js. You bundle it together with the artifacts that you need, upload it to VSTS and voila, you have created your own custom task. What that means is if you can script something, you can get VSTS to do it. Or in other words, you can literally make this build system do whatever you want.

## Release Definition
* Create a release definition to define the process for running the script in two environments.

  ![Screenshot](/Images/VSTS-Pic-17.png)

* A release definition is a collection of environments to which the application build artifacts are deployed. It also defines the actual deployment process for each environment, as well as how the artifacts are promoted from one environment to another.

  ![Screenshot](/Images/VSTS-Pic-18.png)

* Create a release definition.

  ![Screenshot](/Images/VSTS-Pic-19.png)

* Choose a source that publishes the artifacts to be deployed.

  ![Screenshot](/Images/VSTS-Pic-25.png)

* The first thing you do is you define all of your environments.

  ![Screenshot](/Images/VSTS-Pic-26.png)

* Then for each environment, you get to set quality gates going into the environment and going out. You can set as gate keepers individuals, or groups of people.

  ![Screenshot](/Images/VSTS-Pic-21.png)

* Then for each environment, you set the tasks that you want the deployment to do.

  > Once again, out of the box, you have a full set of tasks that can do all sorts of stuff. But if you can't find the task that you need out of the box, go to the Marketplace and see if the community has already built what you need. And if you can't find it in the Marketplace. You can easily create your own custom task. Just like the build, a custom task is nothing more than powershell or node js. So once again, you can create tasks that can make this deployment system do anything. As the your app is deployed in each environment, people will need to approve it so it can flow through the approval gates until eventually it reaches all the way to production.

  ![Screenshot](/Images/VSTS-Pic-20.png)

* Since we have already set up our CI/CD pipeline, if this build is successful, it starts deploying in our CD pipeline. Here we can see the deployment happen in real time as well.

## Tests
* Here is where you can manage your project test lifecycle using the Visual Studio Team Services.

  ![Screenshot](/Images/VSTS-Pic-34.png)

## Test Plans
* You can create manual test plans designed efficiently to validate your software milestones. You will also be able to create and execute manual tests that can be consistently reproduced over the course of each release.

  ![Screenshot](/Images/VSTS-Pic-35.png)
 
 * Assign pre-defined test cases to your user acceptance testers and run to validate changes.

   ![Screenshot](/Images/VSTS-Pic-36.png)

## Load Tests
* Load Testing allow you to stress the application and review how it behaves under a different load of users.  This allows us to take actions on the current infrastructure adding more capacities for the times we think we will need it.  You can automaticly run a load test during a build or release definition.  To trigger a load test, use the Visual Studio Team Services Cloud-based Load Test Service. The Cloud-based Load Test Service is based in Microsoft Azure and can be used to test your app's performance by generating load on it.

  ![Screenshot](/Images/VSTS-Pic-40.png)

* Create and run high-scale load tests, analyze results – all using the browser.

  ![Screenshot](/Images/VSTS-Pic-41.png)

## Dashboards

* The Overview page provides access to a default team dashboard which you can customize by adding, removing, or rearranging the tiles.

  ![Screenshot](/Images/VSTS-Pic-50.png)

* Share progress and status with your team using configurable team dashboards.Each tile corresponds to a widget that provides access to one or more features or functions.

## Useful References
* [Visual Studio Team Services, Getting Started](https://www.visualstudio.com/)
* [Visual Studio Team Services, Product Updates](https://www.visualstudio.com/team-services/updates/)
* [Visual Studio Team Services, Support](https://www.visualstudio.com/team-services/support/)
