class InstancesController < ApplicationController
  before_action :authenticate_user!
  def show
    @instance = Instance.find(params[:id])
    @mission = @instance.mission
    @members = @instance.members

    if @instance.state == "teaming"
      #列出所有可被邀請的使用者
      @candidates = @instance.invitable_users
      # @instance.inviting_users 是正在邀請的使用者
    end

    #如果不同的instance.state, render 不同的template
    case @instance.state
    when "teaming"
      render "teaming"
    when "in_progress"
      render "in_progress"
    when "complete"
      render "complete"
    when "abort"
      render "abort"
    else
      flash[:alert] = "任務關閉中"
      redirect_to root_path
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
