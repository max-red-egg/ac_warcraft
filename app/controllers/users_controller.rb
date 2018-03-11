class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def update

    @user = User.find(params[:id])

    if @user.update_attributes(user_params) 
      flash[:notice] = "成功更新個人資料！"
      redirect_to user_path(@user)
    else
      flash[:alert] = "資料更新失敗！"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :description, :avatar, :state, :available)
  end
end
