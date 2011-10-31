class Admin::ImagesController < Admin::ApplicationController
  resources_controller_for :images

  private

  def find_resources
    resource_service.page(params[:page]).per(15)
  end
  
end
