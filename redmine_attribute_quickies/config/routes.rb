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

RedmineApp::Application.routes.draw do

  # resource quickies creation and administration
  resources :projects do #project
    member do #project_names
      scope 'settings' do #only for settings
        resources :attribute_quickies, :param => :attribute_quicky_id, :except => :show #all necessary routes
      end
    end
  end

  # additional link for resource quickies creation and administration
  match '/projects/:id/settings/attribute_quickies/preview/notes' => 'attribute_quickies#issue', :as => 'preview_attribute_quickies_notes', :via => [:get]

  # link to retrieve last issue changes
  match '/projects/:id/settings/attribute_quickies/issue/attributes' => 'attribute_quickies#issue_attributes', :as => 'attribute_quickies_issue_attributes', :via => [:put]
  
end
