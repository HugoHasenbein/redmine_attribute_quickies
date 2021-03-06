# encoding: utf-8
#
# Redmine plugin for quick attribute setting of redmine issues
#
# Copyright © 2018 Stephan Wenzel <stephan.wenzel@drwpatent.de>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#

require 'redmine'

Redmine::Plugin.register :redmine_attribute_quickies do
  name 'Redmine Attribute Quickies'
  author 'Stephan Wenzel'
  description 'This is a plugin for Redmine bulk edit bulk attributes'
  version '1.0.2'
  url 'https://github.com/HugoHasenbein/redmine_attribute_quickies'
  author_url 'https://github.com/HugoHasenbein/redmine_attribute_quickies'

  # link to settings page
  settings :default => { 
	 'attribute_quickies_active' => '1',
   },
   :partial => 'plugin_settings/attribute_quickies/settings'

  # manage permissions -> Redmine->Administration->Roles and permissions
  project_module :redmine_attribute_quickies do
	permission :view_attribute_quickies,
			   :attribute_quickies => [:index, :show]

	permission :edit_attribute_quickies,
			   :attribute_quickies => [:new, :create, :edit, :update, :destroy, :issue, :issue_attributes]
  end

end

require 'redmine_attribute_quickies'