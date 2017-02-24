class SessionsController < ApplicationController
  def new
    redirect_to current_user if current_user
  end

  def create
    user = User.find_by username: params[:username]
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user, notice: "Welcome back!"
    else
      redirect_to :back, notice: "Username and password do not match"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end
end