class InstancesController < ApplicationController
  before_action :authenticate_user!

  def index
    @instances_in_progress = current_user.instances.where(state: 'in_progress')
    @instances_teaming = current_user.instances.where(state: 'teaming')
    @instances_history = current_user.instances.where(state: ['complete', 'abort'])
  end

  def show
    @instance = Instance.find(params[:id])
    @mission = @instance.mission
    @members = @instance.members

    if @instance.state == "teaming"

      # 篩選使用者 & 列出所有可被邀請的使用者
      @filterrific = initialize_filterrific(
            User,
            params[:filterrific],
            select_options: {
              sorted_by: User.options_for_sorted_by,
              with_gender: ['male', 'female'],
              range_level: [['0-4', '0'], ['5-9', '5'], ['10-14', '10'], ['15-19', '15']],
            }
          ) or return
      @candidates = @filterrific.find.can_be_invited(@instance).page(params[:page])

      # @instance.inviting_users 是正在邀請的使用者
      #所有邀情函
      @invitations = @instance.inviting_invitations.includes(:user)
      #剩下可發送的邀請函數量
      @remaining_invitations_count = @instance.remaining_invitations_count

      respond_to do |format|
        format.html
        format.js
      end

    end
  end

  def submit
    instance = Instance.find(params[:id])
    # 需要為成員而且副本狀態是進行中才能夠提交副本
    if instance.is_member?(current_user) && instance.state == "in_progress"
      if instance.update!(submit_params)
        flash[:notice] = "任務完成！"
        # 更改instance狀態
        instance.complete!
        redirect_to instance_path(instance)
      else
        flash[:alert] = "提交失敗！"
        redirect_to instance_path(instance)
      end
    else
      flash[:alert] = "存取禁止"
      redirect_back(fallback_location: root_path)
    end
  end

  def abort
  # 放棄任務
    #使用者可以直接中止任務
    instance = Instance.find(params[:id])
    if instance.is_member?(current_user) && (instance.state == "teaming" || instance.state == "in_progress")
      #確認是團隊成員然後副本是 teaming 和 in_progress
      instance.abort!
      flash[:notice] = "任務中止"
      # 回到instance#show
      redirect_to instance_path(instance)
    #不是成員
    else
      flash[:alert] = "存取禁止"
      redirect_back(fallback_location: root_path)
    end
  end




  private
  def submit_params
    params.require(:instance).permit(:answer)
  end
end
