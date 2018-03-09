class Admin::BaseController < ApplicationController
  before_action :aunthenticate_admin

  private
  def aunthenticate_admin
    unless current_user.admin?
      flash[:alert] = "Not Allow!"
      redirect_to root_path
    end
  end

end
