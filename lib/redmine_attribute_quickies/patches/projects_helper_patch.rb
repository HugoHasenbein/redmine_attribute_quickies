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

module RedmineAttributeQuickies
  module Patches
    module ProjectsHelperPatch
	  def self.included(base)
		base.send(:include, InstanceMethods)
		base.class_eval do
		  unloadable

		  alias_method_chain :project_settings_tabs, :attribute_quicky_settings
		end
	  end

	  module InstanceMethods
  
		# Append tab for attribute quicky settings to project settings tabs.
		def project_settings_tabs_with_attribute_quicky_settings
		  tabs = project_settings_tabs_without_attribute_quicky_settings
	  
		  if Setting['plugin_redmine_attribute_quickies']['attribute_quickies_active'] 
			 
			# we will get all calls through this interface
			# therefore, check routing resources get/post - new/create/edit/update/destroy 
			# for dispatching to the right controller action
		
			if params[:attribute_quicky_id].blank? && request.get?
			  # nothing => index
			  action = {  name:         'attribute_quickies',
						  partial:      'projects/settings/attribute_quickies/index',
						  controller:   'attribute_quickies', #needed only for permission checking
						  action:       :index,               #needed only for permission checking
						  label:        :label_attribute_quicky_plural }
			  tabs << action if User.current.allowed_to?(action, @project)
		
			elsif params[:attribute_quicky_id].present? && request.get?
			  # => show
			  @attribute_quicky = AttributeQuicky.instantiate(params[:attribute_quicky])
			  action = {  name:         'attribute_quickies',
						  partial:      'projects/settings/attribute_quickies/show',
						  controller:   'attribute_quickies', #needed only for permission checking
						  action:       :edit,                #needed only for permission checking
						  label:        :label_attribute_quicky_plural }
			  tabs << action if User.current.allowed_to?(action, @project)

			elsif params[:attribute_quicky_id].blank? && request.post?
			  # was create request => react with edit
			  action = {  name:         'attribute_quickies',
						  partial:      'projects/settings/attribute_quickies/edit',
						  controller:   'attribute_quickies', #needed only for permission checking
						  action:       :edit,                #needed only for permission checking
						  label:        :label_attribute_quicky_plural }
			  tabs << action if User.current.allowed_to?(action, @project)
		  
			elsif params[:attribute_quicky_id].present? && request.put?
			  # was update request => react with edit
			  @attribute_quicky = AttributeQuicky.instantiate(params[:attribute_quicky])
			  action = {  name:         'attribute_quickies',
						  partial:      'projects/settings/attribute_quickies/edit',
						  controller:   'attribute_quickies', #needed only for permission checking
						  action:       :edit,                #needed only for permission checking
						  label:        :label_attribute_quicky_plural }
			  tabs << action if User.current.allowed_to?(action, @project)
			end
		
		  end
		  tabs
		end
	
	  end
	end
  end
end

unless ProjectsHelper.included_modules.include?(RedmineAttributeQuickies::Patches::ProjectsHelperPatch)
  ProjectsHelper.send(:include, RedmineAttributeQuickies::Patches::ProjectsHelperPatch)
end

