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

Rails.configuration.to_prepare do

  # patch helpers and controllers
  require 'attribute_quickies/patches/attribute_quickies_projects_helper_patch'
  ProjectsHelper.send(:include, AttributeQuickiesProjectsHelperPatch)
  
  require 'attribute_quickies/patches/attribute_quickies_application_helper_patch'
  ApplicationHelper.send(:include, AttributeQuickiesApplicationHelperPatch)

  # code hook
  require 'attribute_quickies/hooks/attribute_quickies_issues_bulk_edit_before_save'
  
  # link hooks
  require 'attribute_quickies/hooks/attribute_quickies_css'
  require 'attribute_quickies/hooks/attribute_quickies_context_menu'

end
