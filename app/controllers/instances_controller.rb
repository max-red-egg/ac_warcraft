class InstancesController < ApplicationController
  def show
    @instance = Instance.find(params[:id])
    @mission = @instance.mission
    @members = @instance.members

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

end
