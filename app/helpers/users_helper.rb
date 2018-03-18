module UsersHelper
  def transcript_user_state(state)
    case state
    when true then '開啟'
    when false  then '關閉'
    end
  end
end
