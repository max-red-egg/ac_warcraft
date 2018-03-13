class MissionsController < ApplicationController
  before_action :authenticate_user!
  def index
    @missions = Mission.page(params[:page]).per(20)
  end
  def show 
    @mission = Mission.find(params[:id])
  end

  def challenge
    #挑戰一個任務
    mission = Mission.find(params[:id])
    if current_user.take_mission?(mission)
      #如果user可以挑戰這個任務
      #產生一個新副本
      #使用者available變為busy
      instance = current_user.instances.build(mission_id: params[:id])
      current_user.available = 'busy'
      current_user.save
      instance.save
      flash[:notice] = "挑戰任務成功" 
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = "無法挑戰該任務"
      redirect_back(fallback_location: root_path)
    end
  end
end
