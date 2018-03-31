module MissionsHelper

  def challenge_button(mission,team_user = '')
    # 先確認此任務不是自己發起且正在進行或組隊中的任務
    if !current_user.not_in_banned_mission_list(mission)
        content_tag(:button, '挑戰任務中' , class: "btn btn-dark disabled")
    elsif team_user.present?
      link_to '送出任務邀約', select_user_mission_path(mission, select_user: @user), class: "btn bg-primary"
    elsif current_user.take_mission?(mission) #確認 user 可以挑戰任務

      if mission.participant_number < 2
        link_to "挑戰任務", challenge_mission_path(mission), method: :post, class: "btn bg-primary"
      else
        link_to "開始組隊", challenge_mission_path(mission), method: :post, class: "btn bg-primary"
      end
    else
      content_tag(:button, '等級不足' , class: "btn btn-dark disabled")
    end
  end

end
