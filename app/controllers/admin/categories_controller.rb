class Admin::CategoriesController < Admin::ApplicationController
  resources_controller_for :categories

  

  private

  def find_resources
    resource_service.page(params[:page]).per(15)
  end
  
end
