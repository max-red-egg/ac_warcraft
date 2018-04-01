class ApplicationController < ActionController::Base
  #skip_before_action :verify_authenticity_token, raise: false

  private

  def filterrific_user
    initialize_filterrific(
      User,
      params[:filterrific],
      select_options: {
        sorted_by: User.options_for_sorted_by,
        with_gender: User.options_for_gender,
        with_level: User.options_for_level,
      }
    )
  end

end
