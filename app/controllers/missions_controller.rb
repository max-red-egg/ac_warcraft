class MissionsController < ApplicationController
  before_action :authenticate_user!

  def my_mission
    current_instances = current_user.instances.where(state: ['in_progress','teaming'])

    if current_instances.count > 0
      redirect_to instances_path
    else
      redirect_to missions_path
    end
  end

  def index
    @missions = Mission.order(level: :asc).page(params[:page]).per(20)
  end

  def show
    @mission = Mission.find(params[:id])
    # 如果要看的任務為現在正在進行的任務會重新導向到副本頁面
    # current_instance = current_user.instances.select { |instance| instance.state == 'in_progress' }[0]
    # redirect_to current_instance if current_instance.mission_id == @mission.id
    respond_to do |format|
      format.html
      format.js
    end
  end

  def challenge
    #挑戰一個任務
    mission = Mission.find(params[:id])
    if current_user.take_mission?(mission)
      #如果user可以挑戰這個任務
      #產生一個新副本
      instance = current_user.instances.create(mission_id: params[:id])

      instance.xp = mission.xp
      #設定副本xp值
      #如果有特殊xp加乘 可以在這邊修改

      #current_user.save!
      instance.save!
      flash[:notice] = "挑戰任務成功"
      #redirect_back(fallback_location: root_path)
      redirect_to instance_path(instance)
    else
      flash[:alert] = "無法挑戰該任務"
      redirect_back(fallback_location: root_path)
    end
  end
end
