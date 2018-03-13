module UsersHelper
  def transcript_user_state(state)
    case state
    when 'yes' then '可邀清'
    when 'no'  then '沒空'
    when 'busy' then '任務進行中'
    end
  end
end
