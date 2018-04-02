class Admin::AnnouncementsController < ApplicationController
  before_action :set_announcement , only:[:show,:edit,:update,:destroy]

  def index
    @announcements = Announcement.includes(:author).order(:id)
  end

  def show 
    @announcement = Announcement.includes(:author).find(params[:id])
  end

  def new
    @announcement = Announcement.new
  end

  def create
    @announcement = current_user.announcements.build(announcement_params)
    if @announcement.save
      flash[:notice] = "announcement created!"
      redirect_to admin_announcement_path(@announcement)
    else
      flash[:alert] = "something wrong!"
      render :new
    end

  end

  def edit
  end

  def update
    if @announcement.update(announcement_params)
      flash[:notice] = "announcement updated!"
      redirect_to announcement_mission_path(@announcement)
    else
      render :edit
    end
  end

  def destroy
    @announcement.destroy
    flash[:notice] = "announcement delete"
    redirect_to admin_announcements_path
  end

  private

  def announcement_params

    params.require(:announcement).permit(:title,:content)

  end

  def set_announcement
    @announcement = Announcement.find(params[:id])
  end
end
