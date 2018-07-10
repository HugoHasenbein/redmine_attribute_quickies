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

module AttributeQuickiesIssuesBulkEditBeforeSave
  class Hooks < Redmine::Hook::ViewListener

  def controller_issues_bulk_edit_before_save( context )
	  
	  issue = context[:issue]
  
  # ----------------------------------------------------------------------------------- #
      # special function assign_to_last_author (response function)
	  if context[:params][:issue][:assign_to_last_author].present?
		if issue.journals.length == 0
		  u = issue.author
		else
		  u = Journal.where(:id =>  issue.last_journal_id ).first.user 
		end
		if  issue.assignable_users.any?{|assignable_user| assignable_user == u}
		  issue.assigned_to = u
		end #if
	  end #if

  # ----------------------------------------------------------------------------------- #
      # special function issue_description_action
	  if context[:params][:issue][:issue_description_action].present?
	    case context[:params][:issue][:issue_description_action].to_i
	      when 1 #append
	        issue.description = issue.description_was + context[:params][:issue][:description].presence.to_s
	      when 2 #prepend
	        issue.description = context[:params][:issue][:description].presence.to_s + issue.description_was
	      when 3 #replace
	        # do nothing, value is already replaced 
	    end
	  end

  # ----------------------------------------------------------------------------------- #
      # special function copy attachments
	  if context[:params][:issue][:copy_attachments].present?
	    id = context[:params][:issue][:copy_attachments].to_i
	    attribute_quicky = AttributeQuicky.visible.where(:id => id).first
	    if attribute_quicky.present?
	      if attribute_quicky.attachments.any?
	        attribute_quicky.attachments.each do |attachment|
	          issue_attachment = attachment.copy
	          issue_attachment.file= File.read(attachment.diskfile)
	          issue.attachments << issue_attachment
	          issue_attachment.save
	        end #each
	      end #if
	    end #if
	  end #if

  # ----------------------------------------------------------------------------------- #
      # special function add time entry
	  if context[:params][:issue][:time_entry].present?
	    #time entry must be completed
	    _params = context[:params][:issue][:time_entry]
	    if _params[:hours].present? && _params[:activity_id].present? && _params[:comments].present?
		  _time_entry = TimeEntry.new(context[:params][:issue][:time_entry])
		  _time_entry.spent_on = Date.today
		  _time_entry.user = User.current
		  _time_entry.project = issue.project
		  issue.time_entries << _time_entry
		  _time_entry.save
		end
      end 

  end


  end
end

