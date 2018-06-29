# redmine_attribute_quickies
Plugin for Redmine. With only one click set arbitrary combinations of issue attributes, custom fields and time entries, add comments to journals and add attachments

### Install

1. go to plugins folder

`git clone https://github.com/HugoHasenbein/redmine_attribute_quickies.git`

2. go to redmine root folder

`bundle exec rake redmine:plugins:migrate RAILS_ENV=production NAME=redmine_attribute_quickies`

3. restart server f.i. `sudo /etc/init.s/apache2 restart`

### Use

* In Redmine go to Projects -> Settings -> Attribute-Quickies
* Click 'Create new Attribute Quicky'
* Begin with a **name**, which is displayed in the issue context menue (right click menue) which should be short, concise and describes what it does
* Provide a **brief description**, which is shown in the attribute quickies list in the Attribute-Quickies tab in the project settings menue
* Optionally **Copy** all last attribute changes from an issue of this project, f.i.
  * status
  * assign to
  * priority
  * start date
  * due date
  
To copy last issue changes from an existing issue search the issue by subject or ID in the Issue-template field. Then press *Copy*. 
If a description change is detected you are privided with a drop down list. It lets you choose if the description change should be prepended, appended or if the new description should replace the description of the issue, on which Attribute-Quicky is applied with one click in the issue context menue.

* Optionally fill out **Log Time**
* Optionally choose **Assign to last author**
* Optionally choose **Add comment** and use all macros and issue comment function with full markdown / textile support
* Optionally **Add attachment**

  
