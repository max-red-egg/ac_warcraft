class InvitationsController < ApplicationController
  before_action :authenticate_user!

  def show
  #要驗證只有受邀請的人可以進這個action
    @invitation = Invitation.find(params[:id])
    @inviter = @invitation.user
    @invitee = @invitation.invitee
    @mission = @invitation.instance.mission
  end

  def accept
    #要先做檢覈
    # 1.是不是本人
    # 2.該副本是否已經啟動
    # binding.pry

    @invitation = Invitation.find(params[:id])
    if @invitation.invitee == current_user && @invitation.instance.state == 'teaming'
      @invitation.state = 'accept'
      @invitation.save
      # binding.pry
      flash[:notice] = '接受任務'
      redirect_to instance_path(@invitation.instance)
    elsif @invitation.instance.state == 'in_progress'
      flash[:alert] = '已經有別人搶先一步，接受邀請失敗'
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = '無法接受任務邀請'
      redirect_back(fallback_location: root_path)
    end

  end

  def decline
  end

  def cancel
    #邀請者可以取消邀請
    #invitatoin.state = 'cancel'
    @invitation = Invitation.find(params[:id])
    #只有發起這個邀請的人可以取消邀請
    
    if current_user == @invitation.user && @invitation.state == "inviting"
      @invitation.update!(state: "cancel")
      flash[:notice] = "取消邀請"
      redirect_to instance_path(@invitation.instance)
    else
      flash[:alert] = "操作失敗"
      redirect_back(fallback_location: root_path)
    end
  end
end
