class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :current_user_is_admin?

  def current_user
    return nil if session[:user_id].nil?
    User.find(session[:user_id])
  end

  def current_user_is_admin?
    user = current_user
    return false if user.nil?
    user[:admin]
  end

  def ensure_that_signed_in
    redirect_to signin_path, notice:'you should be signed in' if current_user.nil?
  end

  def ensure_that_admin_signed_in
    redirect_to root, notice:"you don't have the admin rights" unless current_user_is_admin?
  end
end
