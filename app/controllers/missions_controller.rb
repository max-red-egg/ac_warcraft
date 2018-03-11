class MissionsController < ApplicationController
  def index
    @missions = Mission.page(params[:page]).per(20)
  end
  def show 
    @mission = Mission.find(params[:id])
  end
end
