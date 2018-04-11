class ApplicationController < ActionController::Base
  #skip_before_action :verify_authenticity_token, raise: false
  before_action :authenticate_user!
  before_action :recruit_boards_index
  before_action :check_info_completed

  private

  def check_info_completed
    # user登入才做此驗證
    if current_user && current_user.info_not_completed?
      flash[:notice] = "請將個人資料填寫完整！"
      redirect_to edit_user_path(current_user)
    end
  end

  def recruit_boards_index
    @recruit_boards = RecruitBoard.where(state: true).where.not(user_id: current_user).order(id: :desc)
    @my_recruit_boards = RecruitBoard.where(state: true).where(user_id: current_user).order(id: :desc)
    @recruit_mission_count = RecruitBoard.where(state: true).count
  end

  def filterrific_user
    initialize_filterrific(
      User,
      params[:filterrific],
      persistence_id: 'user_filter',
      select_options: {
        sorted_by: User.options_for_sorted_by,
        with_location: User.options_for_location,
        with_level: User.options_for_level,
      }
    )
  end

  def filterrific_mission
    initialize_filterrific(
      Mission,
      params[:filterrific],
      persistence_id: 'mission_filter',
      select_options: {
        sorted_by: Mission.options_for_sorted_by,
        with_tag: Mission.options_for_tag,
      }
    )
  end
end
