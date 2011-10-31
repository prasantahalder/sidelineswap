class Admin::UsersController < Admin::ApplicationController

  resources_controller_for :users

  def update
    @user = find_resource
    @user.login = params[:user]['login']
    if @user.save && @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to admin_user_path(@user)
    else
      render :action => :edit
    end
  end

  private

  def find_resources
    resource_service.order(:login).page(params[:page]).per(15)
  end

end
