# redmine_attribute_quickies
Plugin for Redmine. With only **one click** set arbitrary preconfigurable set of combinations of issue attributes, custom fields and time entries, add comments to journals and add attachments like a **custom workflow**.

![PNG that represents a quick overview](/doc/Overview.png)

### Use case(s)

Manager wants to grant an application-for-leave to staff member. Manager clicks on preconfigured Attribute-Quicky in issue context menu and on just **one click** 
  - sets status to "granted", 
  - sets "assigned to" the last author (the requesting staff member), 
  - leaves comment in issue: "have a nice vacation!",
  - adds an image of a beach scene 
  
or

Support staff receives a phone call and provides support. After providing support on the phone support staff member clicks on preconfigured Attribute-Quicky in issue context menu and on just **one click**
  - sets time log to 1/4 hour for "technical support"
  - leaves comment in issue "technical support for software installation"
  
or
  
Jon Doe wants to return the issue to the last author and clicks a preconfigured Attribute-Quicky in issue context menu
  - set assigned to whoever was last author, like a **respond** - btton

or 

[…] 
  
### Install

1. download plugin and copy plugin folder redmine_attribute_quickies go to Redmine's plugins folder 

2. go to redmine root folder

`bundle exec rake redmine:plugins:migrate RAILS_ENV=production NAME=redmine_attribute_quickies`

3. restart server f.i.

`sudo /etc/init.d/apache2 restart`

### Uninstall

1. go to redmine root folder

`bundle exec rake redmine:plugins:migrate RAILS_ENV=production NAME=redmine_attribute_quickies VERSION=0`

2. go to plugins folder, delete plugin folder redmine_attributes_quickies

`rm -r redmine_attributes_quickies`

3. restart server f.i.

`sudo /etc/init.d/apache2 restart`

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
  
**Important Notice:**: the only way to set/change attribute changers is to copy the attribute changes from an existing issue. After copying the existing issue may be changed, closed or deleted.

To copy last issue changes from an existing issue search the issue by subject or ID in the Issue-template field. Then press *Copy*. 
If a description change is detected you are provided with a drop down list. It lets you choose if the description change should be prepended, appended or if the new description should replace the description of the issue, on which Attribute-Quicky is applied with one click in the issue context menue.

Use the "**Only strict match**" option to only activate this Attribute-Quicky in the issue context menu, if the current issue's attributes under the issue context menu match the previous attributes of the chosen template issue.

*Example:* the template issue's, you choose here, attribute 'A' was changed from 'X' to 'Z'. Attribute-Quicky stores "Change 'A' from 'X' to 'Z'. 

If the current issue under the issue context menu you want to apply the Attribute-Quicky to, has an attribute 'A' with value 'Y', then either a notice is shown next to the Attribute-Quicky in the issue context menu that after an update the change from 'X' to 'Z' would not match or, because the current issue would be changed vom 'Y' to 'Z' instead of from 'X' to 'Z'. 
If "**Only strict match**" is chosen, the Attribute-Quicky will be deactiavted. 

In case the current issue under the issue context menu matches the previous attributes of the template issue, then no notice is shown.

*Use case:* never grant vacation on a closed request. You are free to choose your own rules.

* Optionally fill out **Log Time**
* Optionally choose **Assign to last author**
* Optionally choose **Add comment** and use all macros and issue comment function with full markdown / textile support
* Optionally **Add attachment** - above I added a picture of a friendly dolphin, which I think is a nice guy for granting vacation requests

* Choose **Role** for which this Attribute-Quicky should be active, all or only certain roles
* Choose **Tracker** for which this Attribute-Quicky should be active, all or selected ones

**Save!**

Now you can right click an issue or on many issues at a time in the issue index view "View all issues" or "Custom query" and choose the Attribute-Quicky, which is displayed on top of the context menu. 

**Click!** 

All configured changes are applied to the selected issue(s). Ready!

![PNG that represents use Attribute-Quicky in issue index view](/doc/Use-Attribute-Quicky.png)

Attribute-Quickies honor work-flow permissions and permissions per role, i.e. "View (use) Attribute-Quickies" and "Manage (admin) Attribute-Quickies"

You may add as many Attribute-Quickies as you like. *Good practice:* Use only a few and keep them simple. 

**Have fun!**

### Localisations

* English
* German

### Change-Log

* **1.0.2** minor fixes
* **1.0.1** initial commit
* **1.0.1** Running on Redmine 3.4.6
* **1.0.0** running on Redmine 3.3.3
