class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy, :show]
  before_action :require_admin
  
  def index
    @users = User.includes(:tasks).all
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: "ユーザを作成できました！"
    else
      render :new
    end
  end

  def show
    @tasks = @user.tasks
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "ユーザーの情報が更新されました！"
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: "ユーザーの削除に成功しました！"
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  def require_admin
    unless current_user.admin?
      redirect_to tasks_path, notice: '管理者以外はアクセスできません'
    end
  end
end
