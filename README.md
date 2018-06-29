# redmine_attribute_quickies
Plugin for Redmine. With only **one click** set arbitrary combinations of issue attributes, custom fields and time entries, add comments to journals and add attachments

### Use case(s)

Manager wants to grant an application-for-leave to staff member. Manager clicks on preconfigured Attribute-Quicky in issue context menu and on just **one click** 
  - sets status to "granted", 
  - sets "assigned to" the last author (the requesting staff member), 
  - leaves comment in issue: "have a nice vacation!",
  - adds an image of a beach scene 
  
or

Support staff receives a phone call and provides support. After providing support on the phone support staff member clicks on preconfigured Attribute-Quicky in issue context menu and on just one click 
  - sets time log to 1/4 hour for technical support
  - leaves comment in issue "technical support for software installation"
  
or
  
Jon Doe wants to return the issue to the last author and clicks a preconfigured Attribute-Quicky in issue context menu

or 

[…] 
  
### Install

1. go to plugins folder

`git clone https://github.com/HugoHasenbein/redmine_attribute_quickies.git`

2. go to redmine root folder

`bundle exec rake redmine:plugins:migrate RAILS_ENV=production NAME=redmine_attribute_quickies`

3. restart server f.i.  `sudo /etc/init.s/apache2 restart`

### Uninstall

1. go to redmine root folder

`bundle exec rake redmine:plugins:migrate RAILS_ENV=production NAME=redmine_attribute_quickies VERSION=0`

2. go to plugins folder

`rm -r redmine_attributes_quickies`

3. restart server f.i.  `sudo /etc/init.s/apache2 restart`

### Use

* Go to Projects -> Settings -> Modules and add Attribute-Quickies to project
* Make sure you have the right permission to "Manage Attribute-Quickies" in the roles and permission settings in the Redmine Administration menu

* Go to Projects -> Settings -> Attribute-Quickies
* Click 'Create new Attribute Quicky'

gets you to this dialogue:

![PNG that represents create new Attribute-Quicky dialogue](/doc/Create-Attribute-Quicky.png)

* Begin with a **name**, which is displayed in the issue context menue (right click menue) which should be short, concise and describes what it does
* Provide a **brief description**, which is shown in the attribute quickies list in the Attribute-Quickies tab in the project settings menue
* Optionally **Copy** all last attribute changes from an issue of this project, f.i.
  * status
  * assign to
  * priority
  * start date
  * due date
  
To copy last issue changes from an existing issue search the issue by subject or ID in the Issue-template field. Then press *Copy*. 
If a description change is detected you are provided with a drop down list. It lets you choose if the description change should be prepended, appended or if the new description should replace the description of the issue, on which Attribute-Quicky is applied with one click in the issue context menue.

Use the "**Only strict match**" option to only activate this Attribute-Quicky in the issue context menu, if the current issue's attributes match the prevoius attributes of the chosen template issue. 
*Example:* the template issue's attribute 'A' was changed from 'X' to 'Z'. Attribute-Quicky stores "Change 'A' from 'X' to 'Z'. 
If the current issue you want to apply the Attribute-Quicky on, has an attribute 'A' with value 'Y', then either a notice is shown next to the Attribute-Quicky in the context menu that after update the change from 'X' to 'Z' would not match or, if "**Only strict match**" is chosen, the Attribute-Quicky will be deactiavted. 
In case the current issue matches the previous attributes of the template issue, then no notice is shown.

* Optionally fill out **Log Time**
* Optionally choose **Assign to last author**
* Optionally choose **Add comment** and use all macros and issue comment function with full markdown / textile support
* Optionally **Add attachment** - above I added a picture of a friendly dolphin, which I think is a nice guy granting vacation requests

* Choose **Role** for which this Attribute-Quicky should be active, all or only certain roles
* Choose **Tracker** for which this Attribute-Quicky should be active, all or selected ones

**Save!**

Now you can right click an issue or on many issues at a time in the issue index view "View all issues" or "Custom query" and choose the Attribute-Quicky, which is displayed on top of the context menu. Click! All configured changes are applied to the issue. Ready!

Attribute-Quickies honor work-flow permissions and permissions per role, i.e. "View (use) Attribute-Quickies" and "Manage (admin) Attribute-Quickies"

### Change-Log

* **1.0.1** initial commit
* **1.0.1** Running on Redmine 3.4.6
* **1.0.0** running on Redmine 3.3.3
