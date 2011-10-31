class Admin::UserProfilesController < Admin::ApplicationController
  uses_tiny_mce :only => [:edit, :update]
  resources_controller_for :user_profiles

  private

  def find_resources
    resource_service.page(params[:page]).per(15)
  end
end
