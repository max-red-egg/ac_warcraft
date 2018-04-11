class InstanceMsgsController < ApplicationController

  def create
    # 新增副本的留言
    instance = Instance.find(params[:instance_id])
    #只有member可以留言 而且任務要進行中
    if instance.is_member?(current_user) && instance.state == 'in_progress'
      instance_msg = instance.instance_msgs.create(msg_params)
      instance_msg.user = current_user
      instance_msg.save
      flash[:notice] = '留言已送出'
      redirect_to instance_path(instance)
    else
      flash[:alert] = '無法送出留言'
      redirect_back(fallback_location: root_path)
    end
  end

  private
  def msg_params
    params.require(:instance_msg).permit(:content)
  end
end
