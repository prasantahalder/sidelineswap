class LockersController < ApplicationController
  skip_before_filter :do_breadcrumbs
  before_filter :require_user, :except => [:index, :show]
  before_filter :check_perms, :except => [:index, :show]
  before_filter :set_sorts
#  resources_controller_for :items

  before_filter :do_breadcrumbs

  before_filter :fetch_recent_items, :only => :show
  before_filter :fetch_popular_items, :only => :show
  
  helper_method :pretty_name

#  resources_controller_for :lockers
  def show
	@items = User.find(params[:id]).items.available.page(params[:page]).per(15)
    @user = User.find(params[:id])
	@user_profile = @user.user_profile
        if @user_profile.nil?
          @user_profile = UserProfile.new
        end
  end
  def edit
	@user_profile = UserProfile.new
	@user_profile = current_user.user_profile
	if @user_profile.nil?
		@user_profile = UserProfile.new(:user_id=>current_user.id)
		@user_profile.save
	end
  end
  def update
    @user_profile = UserProfile.new(params[:user_profile])
    @user_profile.user_id = current_user.id

    if @user_profile.save
      flash[:notice] = "Your profile is saved!"
      redirect_back_or_default root_path
    else
      render :action => :show
    end	
  end
 private

  def pretty_name

    if params[:action] == 'show' 
      if current_user.id == params[:id] 
            name = "My Locker Items"
      else
        @user = User.find(params[:id])
        name = "#{@user.login}'s locker"
      end
    end
    name
  end
  
  def set_sorts
    @sorts = [['Position', 'id'], ['Name', 'name'], ['Price', 'price']]
  end

  def check_perms
  end

end
