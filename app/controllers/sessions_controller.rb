class SessionsController < ApplicationController
  def new
    redirect_to current_user if current_user
  end

  def create
    user = User.find_by username: params[:username]
    if user && user.authenticate(params[:password])
      if user.blocked?
        redirect_to :back, notice: "Your account is frozen, please contact admin"
      else
        session[:user_id] = user.id
        redirect_to user_path(user), notice: "Welcome back!"
      end
    else
      redirect_to :back, notice: "Username and password do not match"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end
end