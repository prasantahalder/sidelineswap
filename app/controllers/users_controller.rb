class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]

  def new
    @user = User.new
    @user.shipping_address ||= @user.build_shipping_address
  end

  def create
    @user = User.new(params[:user])
#    @user.shipping_address ||= @user.build_shipping_address

    @user.login = params[:user]['login']
    if @user.save
      # log in user
      @user_session = UserSession.new({:login => @user.login, :password => params[:user][:password]})
      @user_session.save

      flash[:notice] = "Your account is registered!"
      redirect_back_or_default root_path
    else
      render :action => :new
    end
  end

  def show
    @user = @current_user
  end

  def edit
    @user = @current_user
  end

  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to locker_path(@user)
    else
      render :action => :edit
    end
  end
  
  def shipping_address
  	@shipping_address = current_user.shipping_address
  	 @shipping_address.update_attributes(params[:shipping_address]) if request.post?
  	 redirect_to locker_path(current_user.lockers.first)
  end

  
end
