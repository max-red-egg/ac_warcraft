class MissionsController < ApplicationController
  def index
    @missions = Mission.page(params[:page]).per(20)
  end
end
