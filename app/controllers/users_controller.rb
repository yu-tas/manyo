class UsersController < ApplicationController
  before_action :authenticate_user, only: [:show]
  before_action :redirect_if_logged_in, only: [:new, :create]
  before_action :correct_user, only: [:show]
  skip_before_action :login_required, only: [:new, :create]  
  def new
    @user= User.new
  end

  def create
    @user= User.new(user_params)
    if @user.save
      session[user_id] = @user.id
      redirect_to user_path(@user.id), notice: "新規登録ありがとうございます！"
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
      params.require(:user).permit(:name, :email, :password,
                                  :password_confirmation)
  end

  def authenticate_user
    redirect_to login_path unless current_user
  end

  def redirect_if_logged_in
    redirect_to tasks_path if current_user
  end

  def correct_user
    @user = User.find(params[:id])
    unless @user == current_user || current_user.admin? 
      redirect_to tasks_path, alert: "不正なアクセスです。"
    end
  end

end
