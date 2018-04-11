class FollowshipsController < ApplicationController

  def create
    if current_user.id.to_s == params[:following_id]
      flash[:alert] = "無法追蹤自己"
      redirect_back(fallback_location: root_path)
    else
      @followship = current_user.followships.build(following_id: params[:following_id])

      if @followship.save
        flash[:notice] = "成功追蹤"
        redirect_back(fallback_location: root_path)
      else
        flash[:alert] = @followship.errors.full_messages.to_sentence
        redirect_back(fallback_location: root_path)
      end
    end

  end

  def destroy
    @followship = current_user.followships.where(following_id: params[:id]).first
    @followship.destroy
    flash[:alert] = "成功取消追蹤"
    redirect_back(fallback_location: root_path)
  end
end
