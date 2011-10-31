class Admin::ItemsController < Admin::ApplicationController

  resources_controller_for :items

  private

  def find_resources
    resource_service.page(params[:page]).per(15)
  end
  
end
