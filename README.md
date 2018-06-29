# redmine_attribute_quickies
Plugin for Redmine. With only one click set arbitrary combinations of issue attributes, custom fields and time entries, add comments to journals and add attachments

## Install

1. go to plugins folder

`git clone https://github.com/HugoHasenbein/redmine_attribute_quickies.git`

2. go to redmine root folder

`bundle exec rake redmine:plugins:migrate RAILS_ENV=production NAME=redmine_attribute_quickies`

3. restart server f.i. /etc/init.s/apache2 restart
