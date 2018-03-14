class InstancesController < ApplicationController
  def show
    @instance = Instance.find(params[:id])
    @mission = @instance.mission
    @members = @instance.members

    # 選出可以參與此任務的users
    @candidates = User.all.select do |user|
      user.take_mission?(@mission)
    end

    #如果不同的instance.state, render 不同的template
    case @instance.state
    when "teaming"
      render "teaming"
    when "in_progress"
      render "in_progress"
    when "complete"
      render "complete"
    else
      flash[:alert] = "任務關閉中"
      redirect_to root_path
    end
      
  end
  def submit
    instance = Instance.find(params[:id])
    if instance.update!(submit_params)
      flash[:notice] = "任務完成！"

      # 更改instance狀態
      instance.complete!


      redirect_to instance_path(instance)
    else
      flash[:alert] = "提交失敗！"
      redirect_to instance_path(instance)
    end

  end

  private
  def submit_params
    params.require(:instance).permit(:answer)
  end
end
