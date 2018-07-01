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

class AttributeQuicky < ActiveRecord::Base

  unloadable

  include Redmine::SafeAttributes
  
  acts_as_positioned
  acts_as_attachable 
  
  validates_presence_of :name
  validates_presence_of :description

  attr_protected   :id

  serialize        :attribute_list
  serialize		   :time_entry
  
  safe_attributes  'name',					
				   'description',			
				#  'project_id',				
				   'attribute_list',			
				   'attribute_list_action',	
				   'issue_description_action',
				   'add_notes',				
				   'notes',					
				   'private_notes',			
				   'assign_to_last_author',	
				   'issue_id',				
				   'issue_template_id',       
				   'is_for_all',				
				   'visibility',				
				   'position',
				   'time_entry'
  
  belongs_to :issue
  belongs_to :project
  has_and_belongs_to_many :roles,    :join_table => "#{table_name_prefix}attribute_quickies_roles#{table_name_suffix}",    :foreign_key => "attribute_quicky_id"
  has_and_belongs_to_many :trackers, :join_table => "#{table_name_prefix}attribute_quickies_trackers#{table_name_suffix}", :foreign_key => "attribute_quicky_id"
  
  scope :visible, lambda {|*args|
    user = args.shift || User.current
    if user.admin?
      # nop
    elsif user.memberships.any?
      where("#{table_name}.visibility = ?" + 
        " OR #{table_name}.id IN (SELECT DISTINCT aqr.attribute_quicky_id FROM #{Member.table_name} m" +
        " INNER JOIN #{MemberRole.table_name} mr ON mr.member_id = m.id" +
        " INNER JOIN #{table_name_prefix}attribute_quickies_roles#{table_name_suffix} aqr ON aqr.role_id = mr.role_id" +
        " WHERE m.user_id = ?)",
        true, user.id)
    else
      where(:visibility => true)
    end
  }

  # ------------------------------------------------------------------------------------ #
  def <=>(attribute_quicky)
    position <=> attribute_quicky.position
  end

  # ------------------------------------------------------------------------------------ #
  def to_s 
    name 
  end
  
private

end #class