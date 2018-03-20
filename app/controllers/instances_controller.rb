class InstancesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_instance, only: [:show, :submit, :abort, :review]
  before_action :authenticate_instance_member, only: [:show, :submit, :abort, :review]

  def index
    @instances_in_progress = current_user.instances.where(state: 'in_progress')
    @instances_teaming = current_user.instances.where(state: 'teaming')
    @instances_history = current_user.instances.where(state: ['complete', 'abort'])
  end

  def show
    @mission = @instance.mission
    @members = @instance.members

    if @instance.state == "teaming"
      # binding.pry
      # 篩選使用者 & 列出所有可被邀請的使用者
      # binding.pry
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
    end

    if @instance.state == 'in_progress' || @instance.state == 'abort' || @instance.state == 'complete'
      # 組隊完成後，才可以瀏覽留言
      @instance_msgs = @instance.instance_msgs
    end
    if @instance.state == 'abort' || @instance.state == 'complete'
      # 完成後才可到評論頁面
      # current_user在這個副本的所有review
      @current_user_reviews = current_user.reviews.find_by_instance(@instance)
            
    end

  end

  def submit
    # 需要為成員而且副本狀態是進行中才能夠提交副本
    if @instance.state == "in_progress"
      if @instance.update!(submit_params)
        flash[:notice] = "任務完成！"
        # 更改instance狀態
        @instance.complete!
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

  def abort
  # 放棄任務
    #使用者可以直接中止任務
    if @instance.state == "teaming" || @instance.state == "in_progress"
      #確認副本是 teaming 和 in_progress
      @instance.abort!
      flash[:notice] = "任務中止"
      # 回到instance#show
      redirect_to instance_path(@instance)
    #不是成員
    else
      flash[:alert] = "存取禁止"
      redirect_back(fallback_location: root_path)
    end
  end


  def review
  #helper: new_review_instance_path(user)
  #評價你的隊友
    # 功能：
    #  顯示評論 或 讓使用者輸入評論，submit後導向reviews#create action
    # 條件：
    #  instance狀態要在abort 或者 complete
    #  不能評價自己
    #  只能評價一次

    # @user：被評論者
    @user = User.find(params[:user_id])

    # 不能評論自己
    if @user == current_user
      flash[:alert] = '不能評論自己'
      redirect_back(fallback_location: root_path)
    # instance狀態要為abort 或者 complete
    elsif @instance.state != 'complete' && @instance.state != 'abort'
      flash[:alert] = '任務尚未結束'
      redirect_back(fallback_location: root_path)
    end

    # render 'review'. 如果已經被評論過，則顯示該則評論，沒有則顯示form
    if @user.be_reviewed_from?(current_user, @instance)
      # 已評論過，顯示評論
      @review = @user.reviews.find_by_instance_reviewer(@instance,current_user)[0]
      # ind_by_instance_reviewer是Reivew scope,回傳陣列, 但預設應該只有一筆
    else
      # 沒有評論過，讓current_user可以輸入review
      @review = Review.new
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
