class InvitationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_invitation, except: [:index, :sent_index]
  before_action :auth_invitee, only: [:accept, :decline]
  before_action :check_inviting, only: [:accept, :decline, :cancel]

  def index
    @received_invitations = Invitation.where(invitee_id: current_user).order(updated_at: :desc).page(params[:page]).per(8)
    #byebug.order_by_invite_msg
    @received_invitations_msgs_unread_count = current_user.recived_invite_msgs.joins(:invitation).where('invitations.invitee_id = ?', current_user.id).unread.count
    @sent_invitations_msgs_unread_count = current_user.recived_invite_msgs.joins(:invitation).where('invitations.user_id = ?', current_user.id).unread.count
  end

  def sent_index
    @sent_invitations = Invitation.where(user_id: current_user).order(updated_at: :desc).page(params[:page]).per(8)
    @received_invitations_msgs_unread_count = current_user.recived_invite_msgs.joins(:invitation).where('invitations.invitee_id = ?', current_user.id).unread.count
    @sent_invitations_msgs_unread_count = current_user.recived_invite_msgs.joins(:invitation).where('invitations.user_id = ?', current_user.id).unread.count
  end

  def show

    @inviter = @invitation.user                    #邀請者
    @invitee = @invitation.invitee                 #受邀者
    if current_user == @inviter || current_user == @invitee
      #只有邀請者或受邀者才可以瀏覽
      current_user.msg_read!(@invitation)
      @mission = @invitation.instance.mission
      @invite_msgs = @invitation.invite_msgs.order(id: :asc).includes(:user)
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

      @instance = @invitation.instance
      @invitation.send_cancel_msg
      @invitation.state= 'cancel'
      @invitation.save!
      @alert_msg = "取消邀請"

      @remaining_invitations_count = @instance.remaining_invitations_count
      @invitations = @instance.inviting_invitations.includes(:user)

      @filterrific = filterrific_user or return
      @candidates = @filterrific.find.can_be_invited(@instance).page(params[:page]).per(20)

      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path) }
        format.js
      end

    else
      flash[:alert] = "操作失敗"
      redirect_back(fallback_location: root_path)
    end
  end

  def read_all_msg
    invitation = Invitation.find(params[:id])
    current_user.msg_read!(invitation)
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
