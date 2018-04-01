class Admin::AnnouncementsController < ApplicationController
  before_action :set_announcement , only:[:show,:edit,:update,:destroy]

  def index
    @announcements = Announcement.includes(:author).order(:id)
  end

  def show 
    @announcement = Announcement.includes(:author).find(params[:id])
  end
  def set_announcement
    @announcement = Announcement.find(params[:id])
  end
end
