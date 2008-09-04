class <%= controller_class_name %>Controller < ApplicationController
  <%- if parent? -%>
  before_filter :load_<%= parent_underscore_name %>
  <%- end -%>
  
  # GET /<%= table_name %>
  def index
    @<%= table_name %> = <% if parent? %>@<%= parent_underscore_name %>.<%= controller_plural_name %><% else %><%= class_name %>.find(:all)<% end %>

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /<%= table_name %>/1
  def show
    @<%= file_name %> = <%= base %>.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /<%= table_name %>/new
  def new
    @<%= file_name %> = <%= base %>.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /<%= table_name %>/1/edit
  def edit
    @<%= file_name %> = <%= base %>.find(params[:id])
  end

  # POST /<%= table_name %>
  def create
    @<%= file_name %> = <%= base %>.new(params[:<%= file_name %>])

    respond_to do |format|
      if @<%= file_name %>.save
        flash[:notice] = '<%= class_name %> was successfully created.'
        format.html { redirect_to(<%= show_path %>) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /<%= table_name %>/1
  def update
    @<%= file_name %> = <%= base %>.find(params[:id])

    respond_to do |format|
      if @<%= file_name %>.update_attributes(params[:<%= file_name %>])
        flash[:notice] = '<%= class_name %> was successfully updated.'
        format.html { redirect_to(<%= show_path %>) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /<%= table_name %>/1
  def destroy
    @<%= file_name %> = <%= base %>.find(params[:id])
    @<%= file_name %>.destroy

    respond_to do |format|
      format.html { redirect_to(<%= index_path %>) }
    end
  end
  
  <%- if parent? -%>
  protected
  
  def load_<%= parent_underscore_name %>
    @<%= parent_underscore_name %> = <%= parent_class_name %>.find(params[:<%= parent_underscore_name %>_id])
  end
  <%- end -%>
end
