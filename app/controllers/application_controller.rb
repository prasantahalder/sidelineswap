class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user_session, :current_user, :is_admin?

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  
  before_filter :mailer_set_url_options
  before_filter :do_breadcrumbs

after_filter :flash_to_json_header
  def flash_to_json_header
    unless $skip_flash_to_json
      if request.xhr?
        response.headers['X-JSON'] = flash.to_json
        flash.discard
      end
    end
  end

  private

  def do_breadcrumbs
    @crumbs = session[:breadcrumbs] || []

    crumb = {:name => pretty_name.humanize , :path => request.env['PATH_INFO']}

    @crumbs.insert(0, crumb) unless @crumbs[0] == crumb

#    @crumbs.slice!(4..-1)
    @crumbs.slice!(1..-1)

    session[:breadcrumbs] = @crumbs
  end

  def pretty_name
    self.controller_name
  end

  def record_not_found
    render :file => "public/404.html", :status => 404
  end

  def is_admin?
    current_user && current_user.role && current_user.role.name == "admin"
  end

  def is_moderator?
    current_user && current_user.role && current_user.role.name == "moderator"
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to "/"
      return false
    end
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  def fetch_recent_items
    @recent_items = Item.available.recent.limit(4)
    @recent_items = @recent_items.not_by_user(current_user) unless current_user.nil?
  end

  def fetch_popular_items
    @popular_items = Item.available.popular_frontpage.limit(4)
    @popular_items = @popular_items.not_by_user(current_user) unless current_user.nil?
  end
end
