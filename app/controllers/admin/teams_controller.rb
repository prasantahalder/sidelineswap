class Admin::TeamsController < Admin::ApplicationController
  resources_controller_for :teams

  private

  def find_resources
    resource_service.page(params[:page]).per(15)
  end

end
