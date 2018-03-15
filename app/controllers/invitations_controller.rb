class InvitationsController < ApplicationController
  def show
    @invitation = Invitation.find(params[:id])
    @inviter = @invitation.user
    @invitee = @invitation.invitee
    @mission = @invitation.instance.mission
  end

  def accept
  end

  def decline
  end

  def cancel
    #邀請者可以取消邀請
    #invitatoin.state = 'cacel'
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
