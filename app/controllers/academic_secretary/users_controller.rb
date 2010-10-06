class AcademicSecretary::UsersController < ApplicationController
  layout 'admin'
  respond_to :html, :except => [:search_by_fullname, :search_by_username, :autocomplete_form]
  respond_to :json, :only => [:search_by_fullname, :search_by_username]
  respond_to :js, :only => [:autocomplete_form, :show, :index, :edit_status, :update_status, :add_schoolarshi]

  def index
    respond_with(@users = User.postdoctoral_search(params[:search], params[:page], params[:per_page]))
  end

  def new
    respond_with(@user = User.new)
  end

  def create
    respond_with(@user = User.create(params[:user]), :status => :created, :location => academic_secretary_users_path)
  end

  def edit
    respond_with(@user = User.find(params[:id]))
  end

  def show
    respond_with(@user = User.find(params[:id]))
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    respond_with(@user, :status => :updated, :location => academic_secretary_users_path)
  end

  def search_by_fullname
    @records = User.not_in_postdoctoral.search(:fullname_like => params[:term]).all
    render :json => @records.collect { |record| { :id => record.id, :value => record.fullname_or_email, :label => record.fullname_or_email } }
  end

  def search_by_username
    @records = User.login_likes params[:term]
    render :json => @records.collect { |record| { :id => record.login, :value => record.login, :label => record.friendly_email } }
  end
  
  def autocomplete_form
    render :action => 'autocomplete_form.js'
  end

  def edit_status
    @user = User.find params[:id]
    render :action => 'edit_status.js'
  end

  def update_status
    @user = User.find(params[:id])
    @user.update_attribute(:userstatus_id, params[:userstatus_id])
    render :action => 'update_status.js'
  end
  
  def add_schoolarship
    render :action => 'new_schoolarship.js'
  end
end