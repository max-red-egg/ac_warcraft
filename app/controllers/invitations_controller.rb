class InvitationsController < ApplicationController
  def show
    @invitation = Invitation.find(params[:id])
    @inviter = @invitation.user
    @invitee = @invitation.invitee
    @mission = @invitation.instance.mission
  end

  def accept
    #要先做檢覈
    # 1.是不是本人
    # 2.該副本是否已經啟動

    @invitation = Invitation.find(params[:id])
    if @invitation.invitee == current_user && @invitation.instance.state == 'teaming' && @invitation.state == 'inviting'
      @invitation.state = 'accept'
      @invitation.save
      flash[:notice] = '接受任務'
      redirect_to instance_path(@invitation.instance)
    elsif @invitation.instance.state == 'in_progress'
      flash[:alert] = '已經有別人搶先一步，接受邀請失敗'
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = '無法接受任務邀請'
      redirect_back(fallback_location)
    end

  end

  def decline
    # 受邀者可以拒絕邀請
    #要先做檢覈
    # 1.是不是本人
    # 2.invitation 狀態是 inviting
    @invitation = Invitation.find(params[:id])
    if current_user == @invitation.invitee && @invitation.state == 'inviting'
      @invitation.state = 'decline'
      @invitation.save
      flash[:notice] = '拒絕邀請'
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = '::decline: 存取失敗'
      redirect_back(fallback_location: root_path)
    end
  end

  def cancel
    #邀請者可以取消邀請
    #invitatoin.state = 'cancel'
    @invitation = Invitation.find(params[:id])
    if @invitation.state == "inviting"
      @invitation.update!(state: "cancel")
      flash[:notice] = "取消邀請"
      redirect_to instance_path(@invitation.instance)
    else
      flash[:alert] = "操作失敗"
      redirect_back(fallback_location: root_path)
    end
  end

end
