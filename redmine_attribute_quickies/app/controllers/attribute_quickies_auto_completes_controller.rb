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

class AttributeQuickiesAutoCompletesController < ApplicationController

  before_filter :find_project
  
  #------------------------------------------------------------------------------------- #
  def copy_issue_attributes
 
    @journal_details 	= []
    @content 			= ""
    
    if params.key?(:attribute_quicky) && params[:attribute_quicky]key?(:issue_template_id)
      @issue 			= find_issue_by_id(params[:attribute_quicky][:issue_template_id])
      @attribute_list 	= (@issue.present? && @issue.visible?(User.current)) ? issue_attribute_list( @issue ) : []
      @journal_details 	= @attribute_list.map {|attr| JournalDetail.instantiate(attr) }
      @notes 			= params[:attribute_quicky][:notes]
      @content 			= render_to_string :partial => 'issue_attributes_form'
      @hook_content 	= render_to_string :partial => 'issue_attributes_form_hook'

	  respond_to do |format|	  
		format.js { }
	  end #respond_to
	  
    else
      respond_to do |format|	  
		format.js { render :nothing => true}
	  end #respond_to

    end #if
  end

private

  # ------------------------------------------------------------------------------------ #
  def find_issue_by_id( id )
    @issue = Issue.find(id)
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  # ------------------------------------------------------------------------------------ #
  def issue_attribute_list( issue )
  
	attribute_list = []
	journals = issue.
				journals.
				includes(:user, :details).
				references(:user, :details).
				reorder(:created_on, :id).to_a
				
	journals.each_with_index {|j,i| j.indice = i+1}
	journals.reject!(&:private_notes?) unless User.current.allowed_to?(:view_private_notes, issue.project)
	Journal.preload_journals_details_custom_fields(journals)
	journals.select! {|journal| journal.notes? || journal.visible_details.any?}

	journal = journals.last
  
	if journal.present? && journal.details.any? 
  
	  details = journal.visible_details.to_a
	  details.select! {|detail| ['attr', 'cf'].include?(detail['property']) } 
	  details.each do |detail|
		attribute_list << detail.attributes
	  end
	end #if
    attribute_list
  end #def

end #class