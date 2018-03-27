module UsersHelper
  def transcript_user_state(state)
    case state
    when true then '開啟'
    when false  then '關閉'
    end
  end

  def gravatar_for(user, class_value = '')
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: class_value)
  end
end
 