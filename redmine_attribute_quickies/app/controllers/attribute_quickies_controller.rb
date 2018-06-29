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

class AttributeQuickiesController < ApplicationController

  unloadable

  before_filter :find_project #filter is part of redmine
  before_filter :authorize # filter is part of redmine
  before_filter :find_attribute_quicky, :only => [:show, :update, :edit ]
  before_filter :build_new_attribute_quicky_from_params, :only => [:new, :create, :issue, :issue_attributes]
  
  helper :issues 
  helper :custom_fields 
  helper :attachments 
  helper :timelog

  # ------------------------------------------------------------------------------------ #
  def index
    @attribute_quickies = AttributeQuicky.where(:project_id => @project.id).order(:position).to_a
  end #def

  # ------------------------------------------------------------------------------------ #
  def show
    edit
    render :action => 'edit'
  end #def
  
  # ------------------------------------------------------------------------------------ #
  def new
    # before filter: build_new_attribute_quicky_from_params
  end #def
  
  # ------------------------------------------------------------------------------------ #
  def create
	# this is a call from an objected (first time) edit (or new) form
	
    @attribute_quicky.save_attachments(params[:attachments])
        
	if @attribute_quicky.save	
 	  flash[:notice] = l(:attribute_quickies_notice_successful_create)
	  render :action => 'edit', :attribute_quicky => params[:attribute_quicky]
	else
	  flash[:error] = l(:attribute_quickies_notice_erroneus_create)
	  render :action => 'new', :attribute_quicky => params[:attribute_quicky]
	end
	
     flash.discard
	 return
	
  end #def
  
  # ------------------------------------------------------------------------------------ #
  def edit
    # before_filter: find_attribute_quicky
    # do not compile attribute list, keep original copy
    @issue = @attribute_quicky.presence && @attribute_quicky.issue
     new_issue unless @issue.present?
    @attribute_quicky.issue_id = nil if @issue.blank? || !@issue.visible?    
    @journal_details = @attribute_quicky.attribute_list.presence && @attribute_quicky.attribute_list.map {|attr| JournalDetail.instantiate(attr) }
    @journal_details ||= []
    @notes = @attribute_quicky.notes
    @attribute_quicky.issue_template_id = nil #unset to prevent overiding formerly copied attributes at next save action
    @time_entry = TimeEntry.new(@attribute_quicky.time_entry)
     
  end #def
  
  # ------------------------------------------------------------------------------------ #
  def update
    #before_filter: find_attribute_quicky
    
    if request.format.to_s =~ /text\/html/ 
      # this is a call from a user edited form

      @issue = Issue.where(:id => params[:attribute_quicky][:issue_template_id].to_i).first if params[:attribute_quicky].present? && params[:attribute_quicky][:issue_template_id].present?
       params[:attribute_quicky].except!(:issue_template_id) if @issue.blank? && params[:attribute_quicky].present? && params[:attribute_quicky][:issue_template_id].present?
       new_issue if @issue.blank?
       new_issue if !@issue.visible?(User.current)
	  @attribute_quicky.update_attributes( params[:attribute_quicky] )
      
      if !@issue.new_record? #we have a real new input
        @attribute_quicky.issue = @issue
	      compile_attribute_list
	    @attribute_quicky.attribute_list = @attribute_list  	    
	  else
	    @attribute_list = @attribute_quicky.attribute_list
	  end
	  
	  @journal_details = @attribute_list.map {|attr| JournalDetail.instantiate(attr) }
	  @notes = @attribute_quicky.notes
	  
	  @attribute_quicky.save_attachments(params[:attachments])

	  new_time_entry
	  if params.key?(:time_entry)
	    @time_entry.safe_attributes = params[:time_entry]
	    @attribute_quicky.time_entry = params[:time_entry]
	  else
	     @attribute_quicky.time_entry = {}
	  end

	  if @attribute_quicky.save	
		feedback = l(:attribute_quickies_notice_successful_update, :id => @attribute_quicky.id )
		flash[:notice] = feedback
	  else
		feedback = l(:attribute_quickies_notice_erroneus_update, :id => @attribute_quicky.id )
		flash[:error] = feedback
	  end

    else 
	  #this is a call from javascript to reposition item in list
	  if params.key?(:attribute_quicky) && params[:attribute_quicky].key?(:position)
	    @attribute_quicky.position = params[:attribute_quicky][:position]
	    @attribute_quicky.save #if this did not work - just ignore
	  end
    end
     
    respond_to do |format|
	
	  format.html { render :action => 'edit', :attribute_quicky => params[:attribute_quicky]
					flash.discard
				  }
				  
	  format.js   { render :nothing => true 
	              } # for positioning with javascript
    end

  end #def
  
  # ------------------------------------------------------------------------------------ #
  def destroy
    AttributeQuicky.find(params[:attribute_quicky_id]).destroy
    redirect_to :controller => 'projects', 
    			:action => 'settings', 
    			:id => @project, 
	  			:tab => 'attribute_quickies'
  rescue
    flash[:error] = l(:attribute_quickies_notice_delete_error, :id => @attribute_quicky.id )
    redirect_to :controller => 'projects', 
    			:action => 'settings', 
    			:id => @project, 
	  			:tab => 'attribute_quickies'
  end #def
  
  # ------------------------------------------------------------------------------------ #
  def issue
   
    @attachments = []

    render :layout => false

  end #def

  # ------------------------------------------------------------------------------------ #
  def issue_attributes

    @journal_details = []
    @content = ""
    if params[:attribute_quicky].present? && params[:attribute_quicky][:issue_template_id].present?
      @issue = Issue.where(:id=>params[:attribute_quicky][:issue_template_id]).first
      @attribute_list =  (@issue.present? && @issue.visible?(User.current)) ? issue_attribute_list( @issue ) : []
      @journal_details = @attribute_list.map {|attr| JournalDetail.instantiate(attr) }
      @notes = params[:attribute_quicky][:notes]
      @content = render_to_string :partial => 'issue_attributes_form'
      if @issue.present?
        @hook_content = render_to_string :partial => 'issue_attributes_form_hook'
      else
        @hook_content = ""
      end

	  respond_to do |format|
		format.js { }
	  end #respond_to
	  
    else
      respond_to do |format|
		format.js { render :nothing => true}
	  end #respond_to

    end #if
        
  end #def

private

  # ------------------------------------------------------------------------------------ #
  def find_attribute_quicky
    @attribute_quicky = AttributeQuicky.find(params[:attribute_quicky_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  # ------------------------------------------------------------------------------------ #
  def find_issue_by_id( id )
    @issue = Issue.find(id)
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  # ------------------------------------------------------------------------------------ #
  def compile_attribute_list
  
	@attribute_list = []
    if @attribute_quicky.issue_id && @attribute_quicky.issue.present? && @attribute_quicky.issue.visible?(User.current)
      @issue = @attribute_quicky.issue
	  journals = @issue.journals.includes(:user, :details).
					  references(:user, :details).
					  reorder(:created_on, :id).to_a
	  journals.each_with_index {|j,i| j.indice = i+1}
	  journals.reject!(&:private_notes?) unless User.current.allowed_to?(:view_private_notes, @issue.project)
	  Journal.preload_journals_details_custom_fields(journals)
	  journals.select! {|journal| journal.notes? || journal.visible_details.any?}
 
	  journal = journals.last
	
	  if journal.present? && journal.details.any? 
	
		details = journal.visible_details.to_a
		details.select! {|detail| ['attr', 'cf'].include?(detail['property']) } 
		details.each do |detail|
		  @attribute_list << detail.attributes.except!('id')
		end
	  end #if
	end #if

  end #def
  
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
  
  
  # ------------------------------------------------------------------------------------ #
  def build_new_attribute_quicky_from_params
  
    @attribute_quicky = AttributeQuicky.new
    @attribute_quicky.project = @project
     new_time_entry
    
    if params.key?(:attribute_quicky)

      @attribute_quicky.safe_attributes= params[:attribute_quicky] 
      @attribute_quicky.project = @project
      
      @issue = Issue.where(:id => params[:attribute_quicky][:issue_template_id].to_i).first if params[:attribute_quicky].key?(:issue_template_id)
       new_issue if @issue.blank?
       new_issue unless @issue.visible?(User.current)
      @attribute_quicky.issue = @issue

       compile_attribute_list 
      @attribute_quicky.attribute_list = @attribute_list  

	  @journal_details = @attribute_list.map {|attr| JournalDetail.instantiate(attr) }
	  
	  @notes = @attribute_quicky.notes
	  @notes ||= ""
	  
	  if params.key?(:time_entry)
	    @time_entry.safe_attributes = params[:time_entry]
	    @attribute_quicky.time_entry = params[:time_entry]
	  else
	     @attribute_quicky.time_entry = {}
	  end
	  	  
    else
      new_issue
      @attribute_quicky.issue = @issue
	  @journal_details = []
	  @notes = ""
    end
    
  end #def

  # ------------------------------------------------------------------------------------ #
  def new_issue
 
    @issue = Issue.new
    @issue.project = @project
    
    if @issue.project
      @issue.tracker ||= @issue.allowed_target_trackers.first
      
      if @issue.tracker.nil?
        if @issue.project.trackers.any?
          # none of the project trackers is allowed to the user
          render_error :message => l(:error_no_tracker_allowed_for_new_issue_in_project), :status => 403
        else
          # project has no trackers
          render_error l(:error_no_tracker_in_project)
        end #if
        return false
      end #if
      
      if @issue.status.nil?
        render_error l(:error_no_default_issue_status)
        return false
      end #if
      
    elsif request.get?
      render_error :message => l(:error_no_projects_with_tracker_allowed_for_new_issue), :status => 403
      return false
    end #if
  
  end #def

  # ------------------------------------------------------------------------------------ #
  def new_time_entry
    @time_entry = TimeEntry.new
  end #def  

end #class