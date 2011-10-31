class Admin::SwapsController < Admin::ApplicationController
  before_filter :require_user
  resources_controller_for :swaps

  private

  def find_resources
    resource_service.page(params[:page]).per(15)
  end

end
