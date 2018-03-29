class RecruitBoardsController < ApplicationController
  def index
    @recruit_boards = RecruitBoard.where(state: true)
    # binding.pry
  end

  def create
    recruit_board = current_user.recruit_boards.build(user_id: current_user.id, instance_id: params[:instance_id])
    # binding.pry
    recruit_board.save
    redirect_to recruit_boards_path
  end

  def destroy
    recruit_board = RecruitBoard.find(params[:id])
    recruit_board.delete
    redirect_to recruit_boards_path
  end

  def accept
    recruit_board = RecruitBoard.find(params[:id])
    instance = recruit_board.instance
    inviter = recruit_board.user
    # binding.pry
    #確認點擊的使用者可以接受邀請
    if instance.can_invite?(current_user)
      #產生邀請
      invitation = inviter.invitations.build(instance_id: instance.id, invitee_id: current_user.id)
      invitation.save
      # 直接接受邀請
      invitation.send_accept_msg
      invitation.state = 'accept'
      invitation.save
      # binding.pry
      flash[:notice] = '接受緊急徵招!'
      recruit_board.state = false
      recruit_board.save
      redirect_to instance_path(invitation.instance)

    else
      #不能收invite
      flash[:alert] = '不能接受緊急徵招！'
      redirect_back(fallback_location: root_path)
    end
  end

end
