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

class CreateAttributeQuickies < ActiveRecord::Migration

  def self.up
    create_table :attribute_quickies do |t|
      t.column :name,						:string
      t.column :description,				:text
      t.column :project_id,					:integer
      t.column :attribute_list,				:text
      t.column :strict_match,				:boolean, :default => false, :null => false	
      t.column :issue_description_action,	:integer	
      t.column :add_notes,					:boolean
      t.column :notes,						:text
      t.column :private_notes,				:boolean
      t.column :assign_to_last_author,		:boolean
      t.column :issue_id,					:integer
      t.column :issue_template_id,          :integer
      t.column :is_for_all,					:boolean, :default => false, :null => false
      t.column :visibility,					:boolean, :default => false, :null => false
      t.column :position,					:integer, :default => nil
      t.column :time_entry,                 :text
    end
  end

  def self.down
    drop_table :attribute_quickies
  end
end
