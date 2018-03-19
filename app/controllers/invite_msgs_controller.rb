class InviteMsgsController < ApplicationController
  before_action :authenticate_user!

  def create
    # 新增邀請函的留言
    invitation = Invitation.find(params[:invitation_id])
    if (current_user == invitation.user || current_user == invitation.invitee) && invitation.state == 'inviting'
      invite_msg = invitation.invite_msgs.create(msg_params)
      invite_msg.user = current_user
      invite_msg.save

      @invite_msgs = invitation.invite_msgs.includes(:user)

      invitation.time_updated!
    else
      flash[:alert] = '無法送出留言'
      redirect_back(fallback_location: root_path)
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  private
  def msg_params
    params.require(:invite_msg).permit(:content)
  end
end
