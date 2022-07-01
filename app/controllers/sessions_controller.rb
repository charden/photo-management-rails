class SessionsController < ApplicationController
  include SessionsHelper

  def new
  end

  def create
    @user = User.new(session_params)
    unless @user.valid?
      render :new
      return
    end

    user = User.find_by(name: session_params[:name])
    if user && user.authenticate(session_params[:password])
      login user
      redirect_to root_path
    else
      @user.errors.add(:base, "ユーザーIDとパスワードが一致するユーザーが存在しません")
      render 'new'
    end
  end

  def destroy
    logout
    redirect_to login_path
  end

  def session_params
    params.permit(:name, :password)
  end
end
