class Admin::MissionsController < Admin::BaseController
  before_action :set_mission , only:[:show,:edit,:update,:destroy]

  def index
    @missions = Mission.all.order(:id)
  end

  def show 
    @mission = Mission.find(params[:id])
  end

  def new
    @mission = Mission.new
  end

  def create
    @mission = Mission.new(mission_params)
    if @mission.save
      flash[:notice] = "mission created!"
      redirect_to admin_mission_path(@mission)
    else
      flash[:alert] = "something wrong!"
      render :new
    end

  end

  def edit
  end

  def update
    update_params = mission_params
    @mission.tag_list = update_params[:tag_list]
    update_params.delete(:tag_list)
    if @mission.update(update_params)
      flash[:notice] = "mission updated!"
      redirect_to admin_mission_path(@mission)
    else
      render :edit
    end
  end

  def destroy
    @mission.destroy
    flash[:notice] = "mission delete"
    redirect_to admin_root_path
  end

  private

  def mission_params

    params.require(:mission).permit(:name,:level,:description,:participant_number,:invitation_number,:image, :tag_list, :xp)

  end

  def set_mission
    @mission = Mission.find(params[:id])
  end

end
