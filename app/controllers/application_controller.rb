class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :save_return_to_url

  rescue_from CanCan::AccessDenied do |exception|
    logger.warn "AccessDenied: #{exception}"
    redirect_to root_url, :alert => exception.message
  end

  def not_authenticated
    return redirect_to(root_path, :alert => "You do not have access to this page.") if current_user
    redirect_to signin_path, :alert =>  "First signin to access this page."
  end

  def current_cart
    @cart ||= Cart.where(id: session[:cart_id]).first if session[:cart_id]
    @cart ||=create_new_cart
    check_cart_ownership
    @cart.decorate
  end
  def create_new_cart
    cart = Cart.create(user: current_user)
    session[:cart_id] = cart.id
    cart
  end
  helper_method :current_cart

  def return_to_url
    session[:return_to_url] || root_url
  end
  def save_return_to_url
    session[:return_to_url] = request.url if request.get? && controller_name != "sessions" && controller_name != "registration"
  end

  #######
  private
  #######
  def check_cart_ownership
    @cart = create_new_cart if @cart.user && current_user && @cart.user_id != current_user.id
  end
end
