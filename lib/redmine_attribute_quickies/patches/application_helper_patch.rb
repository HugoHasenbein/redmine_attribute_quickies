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
	module ApplicationHelperPatch
	  def self.included(base)
		base.send(:include, InstanceMethods)
		base.class_eval do
		  unloadable
				  
	  # ------------------------------------------------------------------------------#
		  def attribute_quickies_for_context_menu( issues )

			attribute_quickies = AttributeQuicky.where(:project_id => @projects.map(&:id) ).visible.to_a
		
			@aqlist = attribute_quickies.map { |attribute_quicky| 

			   {  :aq => attribute_quicky,
	   
				  :all_trackers_match => issues.all? { |issue|
					 attribute_quicky.trackers.include? issue.tracker
				   },
		 
				  :all_issues_qualify => issues.all? { |issue|
					 compare_attributes( 
					   old_details_to_attributes( attribute_quicky.attribute_list ),
					   issue
					 )
				   },
			  
				  :all_issues_relate_to_aq_project => issues.all? { |issue|
				
					([issue.project.id] + issue.project.ancestors.map(&:id)).include?(attribute_quicky.project_id)
			  
				  },
						 
				  :details_match_array => 
					compare_each_detail(
					  attribute_quicky.attribute_list, 
					  issues
				  )
			   }
			}   
				  
		  end #def

	  # ------------------------------------------------------------------------------#
		  def merge_bulk_params( attribute_quicky )
			bulk_params = details_to_bulk_attributes( attribute_quicky.attribute_list )
			bulk_params.merge!({:notes => attribute_quicky.notes}) if attribute_quicky.add_notes
			bulk_params.merge!({:issue_description_action => attribute_quicky.issue_description_action}) if attribute_quicky.issue_description_action != 0
			bulk_params.merge!({:assign_to_last_author => true}) if attribute_quicky.assign_to_last_author
			bulk_params.merge!({:copy_attachments => attribute_quicky.id}) if attribute_quicky.attachments.any?
			bulk_params.merge!({:time_entry => attribute_quicky.time_entry}) if attribute_quicky.time_entry.present?
			bulk_params
		  end        

	  # ------------------------------------------------------------------------------#
		  def attachments_hash( attribute_quicky )
			att_hash = {}
			attribute_quicky.attachments.each_with_index do |attachment, index|
			  att_hash.merge!({"#{index+1}".to_sym => {:filename => attachment.filename, 
													   :description => attachment.description,
													   :file => attachment.diskfile
													  }
							  })
			end #each
			att_hash
		  end

	  # ------------------------------------------------------------------------------#
		  def old_details_to_attributes( attribute_list )
			details_to_attributes( attribute_list, /attr/, 'old_value').
			merge!({'custom_field_values' => details_to_attributes( attribute_list, /cf/, 'old_value')}).
			merge!(details_to_attributes( attribute_list, /notes/, 'old_value'))
		  end        

	  # ------------------------------------------------------------------------------#
		  def new_details_to_attributes( attribute_list )
			details_to_attributes( attribute_list, /attr/, 'value').
			merge!({'custom_field_values' => details_to_attributes( attribute_list, /cf/, 'value')}).
			merge!(details_to_attributes( attribute_list, /notes/, 'value'))
		  end        
		
	  # ------------------------------------------------------------------------------#
		  def details_to_bulk_attributes( attribute_list )
			empty_to_no_value(details_to_attributes( attribute_list, /attr/, 'value' ), "none").
			merge!({'custom_field_values' => empty_to_no_value(details_to_attributes( attribute_list, /cf/, 'value'), "__none__")})
		  end

	  # ------------------------------------------------------------------------------#
		  def empty_to_no_value( details, replace )
			new_details = {}
			details.each do |key, value|
			  if value.blank?
				new_details.merge!( {key => replace} ) 
				# specialties
				if key == 'parent_id'
				  new_details.merge!( {'parent_issue_id' => replace} )
				  new_details.delete('parent_id ')  
				end
			  else
				new_details.merge!( {key => value} ) 
			  end 
			end
			new_details
		  end

	  # ------------------------------------------------------------------------------#
		  def compare_attributes( attributes, issue )
			result= true
			attributes.each do |key, value|
			  case key
				when 'custom_field_values'
				  result &= compare_custom_fields( value, issue )
				else
				 result &= (value.to_s == issue.attributes[key].to_s)
			  end
			  return result unless result 
			end
			return result
		  end        

	  # ------------------------------------------------------------------------------#
		  def compare_custom_fields( custom_fields_hash, issue )
			result= true
			custom_fields_hash.each do |key, value|
			  result &= (value == issue.custom_field_value(key))
			end
			result
		  end 
	  
	  # ------------------------------------------------------------------------------#
		  def details_to_attributes( attribute_list, prop, key )
			issue_attribute_list= {}
			attribute_list.select { 
			   |attribute| 
				 attribute['property'] =~ prop
			}.each do |attribute| 
				issue_attribute_list.merge!( { attribute['prop_key'] => attribute[key] } )
			end
			issue_attribute_list
		  end #def

	  # ------------------------------------------------------------------------------#
		  def compare_each_detail( attribute_list, issues )
			result_list=[]
			attribute_list.each do |detail|
			  result_list << 
			  [issues.all? { |issue|
				compare_attributes(old_details_to_attributes([detail]), issue )
			   },
			   details_to_strings( [JournalDetail.new(detail.except!('id'))] )
			  ]
			end
			result_list
		  end

		end #base

	  # ------------------------------------------------------------------------------#
	  # ------------------------------------------------------------------------------#
	  end #self

	  module InstanceMethods                
	  end #module
  
	end #module
  end #module
end #module

unless ApplicationHelper.included_modules.include?(RedmineAttributeQuickies::Patches::ApplicationHelperPatch)
  ApplicationHelper.send(:include, RedmineAttributeQuickies::Patches::ApplicationHelperPatch)
end

