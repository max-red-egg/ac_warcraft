class RecruitBoardsController < ApplicationController
  before_action :authenticate_user!
  def index
    @recruit_boards = RecruitBoard.where(state: true)
    # binding.pry
  end

  def create
    id_instance = params[:instance_id].to_i
    unless current_user.recruit_board_repeat?(id_instance)
      recruit_board = current_user.recruit_boards.build(user_id: current_user.id, instance_id: params[:instance_id])
      recruit_board.save
      flash[:notice] = "成功發動本次招募"
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = "本任務招募中"
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    recruit_board = RecruitBoard.find(params[:id])
    if current_user == recruit_board.user
      recruit_board.delete
      flash[:notice] = "成功刪除此招募"
    else
      flash[:alert] = "無法執行本操作"
    end

    redirect_back(fallback_location: root_path)

  end

  def accept

    recruit_board = RecruitBoard.find(params[:id])

    instance = recruit_board.instance
    inviter = recruit_board.user
    # binding.pry

    #確認點擊的使用者可以接受邀請，自己不可以接受自己的徵召
    if instance.state == "teaming" && instance.can_invite?(current_user) && inviter != current_user
      #產生邀請
      invitation = inviter.invitations.build(instance_id: instance.id, invitee_id: current_user.id)
      invitation.save
      # 直接接受邀請
      invitation.send_accept_msg
      invitation.state = 'accept'
      invitation.save
      # binding.pry
      flash[:notice] = '接受緊急招募!'
      recruit_board.state = false
      recruit_board.save
      redirect_to instance_path(invitation.instance)
    else
      #不能收invite
      flash[:alert] = '不能接受本任務招募！'
      redirect_back(fallback_location: root_path)
    end
  end

end
