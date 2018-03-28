class InstancesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_instance, only: [:show, :submit, :abort, :review, :cancel, :save,:edit]
  before_action :authenticate_instance_member, only: [:show, :submit, :abort, :review, :cancel, :save, :edit]

  def index
    @instances_in_progress = current_user.instances.where(state: 'in_progress')
    @instances_teaming = current_user.instances.where(state: 'teaming')
    @instances_history = current_user.instances.where(state: ['complete', 'abort'])
  end

  def history
    @instances_history = current_user.instances.where(state: ['complete', 'abort'])
  end

  def show
    @mission = @instance.mission
    @members = @instance.members

    if @instance.state == "teaming"

      # 篩選使用者 & 列出所有可被邀請的使用者
      @filterrific = initialize_filterrific(
            User,
            params[:filterrific],
            select_options: {
              sorted_by: User.options_for_sorted_by,
              with_gender: ['male', 'female'],
              range_level: [['0-4', '0'], ['5-9', '5'], ['10-14', '10'], ['15-19', '15']],
            }
          ) or return
      @candidates = @filterrific.find.can_be_invited(@instance).page(params[:page])
      # binding.pry
      # @instance.inviting_users 是正在邀請的使用者
      #所有邀情函
      @invitations = @instance.inviting_invitations.includes(:user)
      #剩下可發送的邀請函數量
      @remaining_invitations_count = @instance.remaining_invitations_count

      respond_to do |format|
        format.html
        format.js
      end

    end

    if @instance.state == 'in_progress'
      #只有任務進行中可以留言
      @instance_msg = InstanceMsg.new

      #答案
      @answer = @instance.answer
    end

    if @instance.state == 'in_progress' || @instance.state == 'abort' || @instance.state == 'complete'
      # 組隊完成後，才可以瀏覽留言
      @instance_msgs = @instance.instance_msgs
    end

    if @instance.state == 'abort' || @instance.state == 'complete'
      # 完成後才可到評論頁面
      # 其他人對current_user的review
      @reviews = current_user.reviews.find_by_instance(@instance)
      #current_user對其他人的review
      @reviews_to_other = current_user.review_to_members.find_by_instance(@instance)
    end

  end


  def save
    if @instance.state == "in_progress"
      @instance.update_answer!(submit_params,current_user)
    else
      flash[:alert] = "存取禁止"
      redirect_back(fallback_location: root_path)
    end

  end
  
  def edit
    render :edit
  end

  def submit
    # 需要為成員而且副本狀態是進行中才能夠提交副本
    # binding.pry
    if @instance.state == "in_progress"
      if !@instance.answer.strip.empty?
        flash[:notice] = "任務完成！"
        # 更改instance狀態

        @instance.complete!(current_user)
        redirect_to instance_path(@instance)
      else
        flash[:alert] = "提交失敗！"
        redirect_to instance_path(@instance)
      end
    else
      flash[:alert] = "存取禁止"
      redirect_back(fallback_location: root_path)
    end
  end

  def cancel
    #取消組隊
    #取消後，其他邀請函會自動取消
    if @instance.state == 'teaming'
      flash[:notice] = '放棄組隊！'
      @instance.cancel!
      redirect_to instance_path(@instance)
    else
      flash[:alert] = "存取禁止"
      redirect_back(fallback_location: root_path)
    end

  end

  def abort
  # 放棄任務
    #使用者可以直接中止任務
    if @instance.state == 'in_progress'
      #確認副本是in_progress
      @instance.abort!(current_user)
      flash[:notice] = "任務中止"
      # 回到instance#show
      redirect_to instance_path(@instance)
    #不是成員
    else
      flash[:alert] = "存取禁止"
      redirect_back(fallback_location: root_path)
    end
  end



  private
  def submit_params
    params.require(:instance).permit(:answer)
  end

  def set_instance
    @instance = Instance.find(params[:id])
  end

  def authenticate_instance_member
    #驗證是不是副本成員
    if !@instance.is_member?(current_user)
      flash[:alert] = '::instance:: 存取禁止！'
      redirect_back(fallback_location: root_path)
    end
  end

end
