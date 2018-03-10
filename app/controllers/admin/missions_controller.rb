class Admin::MissionsController < Admin::BaseController
  def index
    @missions = Mission.all
  end

  def show 
    @mission = Mission.find(params[:id])
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def mission_params
  end

end
