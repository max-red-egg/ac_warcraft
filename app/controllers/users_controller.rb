class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    # @users = User.all
    @users = User.page(params[:page]).per(20)
  end

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


  def invite
    # ----說明-----
    # routes:
    #   透過POST invite_user_path(user) 來發送邀請
    # parameters:
    #   user_id: params[:id]
    #   instance_id: params[:instance_id]
    # 新增invitatoin:
    #  - invitation.user = current_user
    #  - invitation.invitee = user
    #  - invitation.instance = instance
    # ------------
    instance = Instance.find(params[:instance_id])
    user = User.find(params[:id])
    # binding.pry
    #確認該使用者可以接受邀請
    if instance.can_invite?(user)
      #產生邀請
      invitation = current_user.invitations.build(instance_id: instance.id, invitee_id: user.id)
      invitation.save
      flash[:notice] = '已送出邀請'
      redirect_back(fallback_location: root_path)
    else
      #不能收invite
      flash[:alert] = '不能送出邀請'
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :description, :avatar, :state, :available)
  end
end
