Great, here we go! You'll be revising files in this repository shortly. To follow a process similar to our team's standard git workflow, you should first clone this training repository to your local machine so that you can make file changes and commits there. 

### :keyboard: Activity: Set up your local repository

Open a git bash shell (Windows) or a terminal window (Mac) and change (`cd`) into the directory you work in for projects in R (for me, this is `~/Documents/Code`). There, clone the repository and set your working directory to the new project folder that was created:
```
git clone git@github.com:{{ user.username }}/{{ repo }}.git
cd {{ repo }}
```

### :keyboard: Activity: Install packages as needed

You may need to install some of the packages for this course if you don't have them already. These are:

* **targets**
* **tarchetypes**
* **tidyverse**
* **dataRetrieval**
* **urbnmapr**
* **rnaturalearth**
* **cowplot**
* **leaflet**
* **leafpop**
* **htmlwidgets**

Install **urbnmapr** with `remotes::install_github('UrbanInstitute/urbnmapr')`.

All the rest should be installable with `install.packages()`.

### :keyboard: Activity: Invite some collaborators

One of the course coordinators was named as your contact for this course. They will provide code reviews during your course. To make it possible for you to request reviews from them, go to the *Settings* tab, *Manage access* subtab, and then click the green button to *Invite a collaborator* to add each of their usernames to your repo.

![How to invite reviewers](https://user-images.githubusercontent.com/12039957/83422503-9fb65e00-a3f7-11ea-8e06-ad87c813247e.png)

<hr><h3 align="center">When you're set up locally, close this issue.</h3>
