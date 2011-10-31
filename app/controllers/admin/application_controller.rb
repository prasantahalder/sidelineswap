class Admin::ApplicationController < ApplicationController
  before_filter :require_user
  before_filter :require_admin

  private

  def require_admin
    redirect_to root_path unless is_admin?
  end
end
