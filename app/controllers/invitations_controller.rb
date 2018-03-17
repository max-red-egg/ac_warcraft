class InvitationsController < ApplicationController
  before_action :authenticate_user!

  def show
  
    @invitation = Invitation.find(params[:id])
    @inviter = @invitation.user                    #邀請者
    @invitee = @invitation.invitee                 #受邀者
    @mission = @invitation.instance.mission
    @invite_msgs = @invitation.invite_msgs.includes(:user)
    if @invitation.state == 'inviting'
      @invite_msg = InviteMsg.new
    end
    #要驗證只有受邀請的人可以進這個action
    unless current_user == @inviter || current_user == @invitee
      flash[:alert] = '存取禁止'
      redirect_back(fallback_location: root_path)
    end
  end

  def accept
    #要先做檢覈
    # 1.是不是本人
    # 2.該副本是否已經啟動
    # binding.pry

    @invitation = Invitation.find(params[:id])
    if @invitation.invitee == current_user && @invitation.instance.state == 'teaming' && @invitation.state == 'inviting'
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
    # 受邀者可以拒絕邀請
    #要先做檢覈
    # 1.是不是本人
    # 2.invitation 狀態是 inviting
    @invitation = Invitation.find(params[:id])
    if current_user == @invitation.invitee && @invitation.state == 'inviting'
      @invitation.state = 'decline'
      @invitation.save
      # 將使用者的狀態變回yes
      current_user.available = 'yes'
      current_user.save
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
