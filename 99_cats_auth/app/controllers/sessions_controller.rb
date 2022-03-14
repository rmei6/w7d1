class SessionsController < ApplicationController
  before_action :require_logged_out, only: [:new, :create]
  def new
    @user = User.new
  end

  def create
    @user = User.find_by_credentials(params[:user][:user_name],params[:user][:password])
    if @user
      login_user!(@user)
      redirect_to user_url(@user)
    else
      render :new
    end
  end

  def destroy
    current_user.reset_session_token!
    session[:session_token] = nil
    @current_user = nil
    redirect_to new_session_url
  end
end