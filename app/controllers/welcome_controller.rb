class WelcomeController < ApplicationController
  before_filter :fetch_recent_items
  before_filter :fetch_popular_items
  
  def index
    @featured_items = Item.where(:available == true).order('RAND()').limit(8)
    @featured_items = @featured_items.available.not_by_user(current_user) unless current_user.nil?
    @featured_stores=Store.where(:available == true).order('RAND()').limit(2)
  end

  private
  
  def pretty_name
    "Home"
  end

end
