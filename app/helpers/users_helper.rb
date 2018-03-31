module UsersHelper
  def transcript_user_state(state)
    case state
    when true then '開啟'
    when false  then '關閉'
    end
  end

  def gravatar_for(user, class_value = '')
    image_tag(gravatar_url(user), alt: user.name, class: class_value)
  end

  def gravatar_url(user)
    if user.email =~ /.*@sample.com\z/
      user.avatar_url
    else
      gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    end
  end

  def repo_links(user, class_value = '')
    user.github_repos.map do |repo|
      link_to repo[0], repo[1], class: class_value
    end
  end
end
 