class ApplicationController < ActionController::Base
  #skip_before_action :verify_authenticity_token, raise: false
  before_action :recruit_boards_index


  private

  def recruit_boards_index
    @recruit_boards = RecruitBoard.where(state: true).where.not(user_id: current_user).order(id: :desc)
    @my_recruit_boards = RecruitBoard.where(state: true).where(user_id: current_user).order(id: :desc)
  end

  def filterrific_user
    initialize_filterrific(
      User,
      params[:filterrific],
      persistence_id: 'user_filter',
      select_options: {
        sorted_by: User.options_for_sorted_by,
        with_gender: User.options_for_gender,
        with_level: User.options_for_level,
      }
    )
  end

end
