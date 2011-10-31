class UserProfilesController < ApplicationController
  before_filter :require_user, :except => [:index, :show]
  before_filter :check_perms, :except => [:index, :show]
  prepend_before_filter :load_enclosing_resources

  resources_controller_for :user_profile, :in => :user

  map_enclosing_resource :user do
    User.find(params[:user_id])
  end

  map_enclosing_resource :team do
    Team.find(params[:team_id])
  end


  uses_tiny_mce :only => [:new, :create, :edit, :update]

  def new
    @user_profile = find_resource || UserProfile.new(:user => enclosing_resource)
    5.times { @user_profile.images.build }
  end

  def edit
    @user_profile = find_resource
	if @user_profile.nil?
		@user_profile = UserProfile.create({:user_id=>current_user.id})
	end
    #5.times { @user_profile.images.build }
	@user_profile.images.build
  end

  def create
    @user_profile = UserProfile.new(params[:user_profile])
    @user_profile.user = current_user
    @user_profile.locker = enclosing_resource if !enclosing_resource.nil? and enclosing_resource.is_a?(Locker)

    unless @user_profile.save
      render :new
    else
      redirect_to user_user_profile_path(enclosing_resource)
    end
  end

  def update
    @user_profile = find_resource
    params[:user_profile][:team_ids] ||= []
    if @user_profile.update_attributes(params[:user_profile])
      #redirect_to user_user_profile_path(@user_profile.user)
      redirect_to locker_path(@user_profile.user)
    else
      #5.times { @user_profile.images.build }
      @user_profile.images.build
      render :edit
    end
  end
  
  private
  
  def find_resource(id = params[:id])
    enclosing_resource.user_profile
  end

  def check_perms
    redirect_back_or_default(root_path) unless current_user == enclosing_resource
  end
end
