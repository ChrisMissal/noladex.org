class UsersController < ApplicationController

  before_filter :require_user, :only => [:edit, :update, :destroy]

  def index
    if params[:category] && params.has_key?(:category) && (params[:category].length > 0 )	
      @users = User.find_by_category(params[:category]).paginate(:per_page => 100, :page => params[:page])
    else
      @users = User.includes(:missions => :category).order('created_at DESC').paginate(:per_page => 100, :page => params[:page])
    end
      respond_to do |format|
        format.html
        format.js
        format.json { render :json => @users.to_json(:include => :missions), :callback => params[:callback] }
        format.xml  { render :xml => @users, :callback => params[:callback] }
      end   
  end

  def new
    @user = User.new
    3.times { @user.missions.build }

    respond_to do |format|
      format.html
      format.xml  { render :xml => @user }
    end
  end

  def edit
    @user = current_user
    (3-@user.missions.size).times { @user.missions.build }
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to(root_url, :notice => 'Thanks for adding yourself to the NOLAdex!') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        (3-@user.missions.size).times { @user.missions.build }

        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      @user = current_user
      if @user.update_attributes(params[:user])
        format.html { redirect_to(root_url, :notice => 'Your profile was successfully updated.') }
        format.xml  { head :ok }
      else
        p @user.errors
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
end