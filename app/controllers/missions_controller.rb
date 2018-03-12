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
    
    if !current_user.busy?
      #如果使用者不是busy
      #產生一個新副本
      instance = current_user.instances.build(mission_id: params[:id])
      instance.save
      flash[:notice] = "挑戰任務成功" 
      redirect_back(fallback_location: root_path)
    else
      #使用者有任務進行中(user state is busy)
      flash[:alert] = "已經有任務進行中，不能再挑戰新任務！"
      redirect_back(fallback_location: root_path)
    end
  end
end
