class MissionsController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    @missions = Mission.all
    instances = Instance.all
    @instance_complete_count = instances.find_complete.count
    @reviews = Review.all
    @users = User.all
    
    # 任務達成率
    @achievement_rate = ((@instance_complete_count.to_f / instances.count.to_f )*100).round

    # 探員龍虎榜
    @top_agents = @users.ordered_by_xp.limit(5)

    # 前線戰情匯報
    @followings_instance_activities = UserInstance.find_by_followings(current_user).limit(10).includes(:instance).includes(:user).includes(:mission).order('instances.updated_at DESC')


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
    # binding.pry
    if current_user.take_mission?(mission) && current_user.not_in_banned_mission_list(mission)
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

  # 由使用者找任務組隊
  def teaming
    @user = User.find(params[:user_id])
    # 找出目前使用者跟欲組隊使用者之間最低的等級
    level = [@user.level, current_user.level].min
    # 撈出參與者大於一人且等級低於兩個使用者的任務
    @missions = Mission.order(level: :asc).where("participant_number > 1 and level <= ?", level).page(params[:page]).per(20)
    render 'index'
  end

  def select_user
    # 先建立instance
    mission = Mission.find(params[:id])
    # 抓出要邀請的user
    user = User.find(params[:select_user])
    # 先建立instance
    # binding.pry
    if current_user.take_mission?(mission) && current_user.not_in_banned_mission_list(mission)
      instance = current_user.instances.create(mission_id: params[:id])
      instance.xp = mission.xp
      instance.save!
      # 直接對user發出邀請
      if instance.can_invite?(user)
      #產生邀請
      invitation = current_user.invitations.build(instance_id: instance.id, invitee_id: user.id)
      invitation.save
      @remaining_invitations_count = instance.remaining_invitations_count
      @invitations = instance.inviting_invitations.includes(:user)
      @filterrific = initialize_filterrific(
            User,
            params[:filterrific],
            select_options: {
              sorted_by: User.options_for_sorted_by,
              with_gender: ['male', 'female'],
              range_level: [['0-4', '0'], ['5-9', '5'], ['10-14', '10'], ['15-19', '15']],
            }
          ) or return
      @candidates = @filterrific.find.can_be_invited(instance).page(params[:page])

      flash[:notice] = "邀請#{user.name}挑戰任務成功"
      #redirect_back(fallback_location: root_path)
      redirect_to instance_path(instance)
      else
        #不能收invite
        flash[:alert] = '不能送出邀請'
        redirect_back(fallback_location: root_path)
      end
    else
      flash[:alert] = "無法挑戰該任務"
      redirect_back(fallback_location: root_path)
    end

  end
end
