class ItemsController < ApplicationController
  skip_before_filter :do_breadcrumbs
  before_filter :require_user, :except => [:index, :show]
  before_filter :check_perms, :except => [:index, :show]
  before_filter :set_sorts
  resources_controller_for :items

  before_filter :do_breadcrumbs

  before_filter :fetch_recent_items, :only => :show
  before_filter :fetch_popular_items, :only => :show
  
  helper_method :pretty_name

  def index
   
  end
  
  def new
    @item = Item.new(:user => current_user)
    @item.locker = enclosing_resource if !enclosing_resource.nil? and enclosing_resource.is_a?(Locker)
    5.times { @item.images.build }
  end

  def edit
    @item = find_resource
    5.times { @item.images.build }
  end

  def create
    @item = Item.new(params[:item])
    @item.user = current_user
    @item.locker = enclosing_resource if !enclosing_resource.nil? and enclosing_resource.is_a?(Locker)
    unless @item.save
      5.times { @item.images.build }
      render :new
    else
      redirect_to item_path(@item)
    end
  end

  def popular
    @skip_paginate = true
    @items = find_resources.popular.paginate(:page => params[:page])
    render :index
  end

  def recent
    @skip_paginate = true
    @items = find_resources.recent.paginate(:page => params[:page])

    render :index
  end

  def comment
    @item = find_resource
    
    c = @item.item_comments.build(:comment => parms[:comment], :user => current_user)
    c.save
  end

  private

  def pretty_name
    unless enclosing_resource.nil?
      if enclosing_resource.class == Locker and 
        enclosing_resource.user == current_user
          name = "My Locker Items"
      else
        name = "#{enclosing_resource} Items"
      end 
    else
      name = "Items"
    end

    if params[:action] == 'new'
      name = "New Item"
    end

    if params[:action] == 'show' && find_resource
      name = find_resource.name
    end
    
    name
  end
  
  def find_resources
    res = resource_service
    res = res.search(params[:search]) unless params[:search].blank? or params[:search]['name_contains'] == 'Enter Item Name'

    unless current_user.nil?
      # only show available items unless they are the current users'
      res = res.where((:available >> true) | (:user_id >> current_user.id))

      # Don't show current user's items unless we're in one of their resources
      unless enclosing_resource == current_user or
          (!enclosing_resource.nil? and enclosing_resource.respond_to?(:user) and enclosing_resource.user == current_user) or
          enclosing_resource.class == Category
        res = res.not_by_user(current_user)
      end
    else
      res = res.where(:available >> true)
    end

    enclosing_resource.add_hit! if enclosing_resource.respond_to?(:add_hit!)

    res = res.order(params[:order]) unless params[:order].blank?

    unless @skip_paginate
      res.page(params[:page]).per(12)
    end
  end

  def find_resource(id = params[:id])
    unless current_user.nil?
      @item = resource_service.where(:id >> id & ((:available >> true) | (:user_id >> current_user.id) ) )
    else
      @item = resource_service.where(:id >> id, :available >> true)
    end

    @item.first.add_hit! if @item.first

    @item.first or raise ActiveRecord::RecordNotFound

  end

  def set_sorts
    @sorts = [['Position', 'id'], ['Name', 'name'], ['Price', 'price']]
  end

  def check_perms
  end

end
