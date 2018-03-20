class InvitationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_invitation, except: [:index]
  before_action :auth_invitee, only: [:accept, :decline]
  before_action :check_inviting, only: [:accept, :decline, :cancel]

  def index
    @sent_invitations = Invitation.where(user_id: current_user)
    @received_invitations = Invitation.where(invitee_id: current_user)
  end

  def show

    @inviter = @invitation.user                    #邀請者
    @invitee = @invitation.invitee                 #受邀者
    if current_user == @inviter || current_user == @invitee
      #只有邀請者或受邀者才可以瀏覽
      @mission = @invitation.instance.mission
      @invite_msgs = @invitation.invite_msgs.includes(:user)
      if @invitation.state == 'inviting'
        @invite_msg = InviteMsg.new
      end
    else
      flash[:alert] = '::Invitation: 禁止瀏覽！'
      redirect_back(fallback_location: root_path)
    end

    respond_to do |format|
      format.html
      format.js
    end

  end

  def accept
    #受邀者可以接受邀請
    #before_aciton :auth_invitee
    #before_aciton :check_inviting
    # binding.pry
    @invitation.send_accept_msg
    @invitation.state = 'accept'
    @invitation.save
    # binding.pry
    flash[:notice] = '接受任務'
    redirect_to instance_path(@invitation.instance)
  end

  def decline
    # 受邀者可以拒絕邀請

    #before_aciton :auth_invitee
    #before_aciton :check_inviting
    @invitation.send_decline_msg
    @invitation.state = 'decline'
    @invitation.save
    flash[:notice] = '拒絕邀請'
    redirect_back(fallback_location: root_path)

  end

  def cancel
    #邀請者可以取消邀請
    #before_aciton :check_inviting

    #只有發起這個邀請的人可以取消邀請
    if current_user == @invitation.user
      @invitation.send_cancel_msg
      @invitation.update!(state: "cancel")
      flash[:notice] = "取消邀請"
      redirect_to instance_path(@invitation.instance)
    else
      flash[:alert] = "操作失敗"
      redirect_back(fallback_location: root_path)
    end
  end

  private
  def set_invitation
    @invitation = Invitation.find(params[:id])
  end

  def auth_invitee
    #確認current_user是受邀者
    if current_user != @invitation.invitee
      flash[:alert] = '::invitation: 操作禁止'
      redirect_back(fallback_location: root_path)
    end
  end

  def check_inviting
    # 檢查邀請函狀態以及組隊狀態
    if @invitation.state != 'inviting' || @invitation.instance.state != 'teaming'
      flash[:alert] = 'Sorry，任務進行中或是邀請函失效！'
      redirect_back(fallback_location: root_path)
    end
  end

end
