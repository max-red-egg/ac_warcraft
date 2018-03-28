module InstancesHelper
  def abort_button(instance)
    if instance.present?
      if instance.state == 'in_progress'
        link_to('放棄任務', abort_instance_path, method: :post, class: "btn btn-danger btn-oval", data: { confirm: "跟組員溝通過了嗎，確定要放棄任務？" })
      end
    end
  end

  def cancel_button(instance)
    if instance.present?
      if instance.state == 'teaming'
        link_to('放棄組隊', cancel_instance_path, method: :post, class: "btn btn-danger btn-oval", data: { confirm: "放棄組隊後，所有邀請函皆會失效。\n\n確定要放棄組隊？" })
      end
    end
  end

  def instance_title(instance)
    case instance.state
    when 'teaming' then '組員招募中'
    when 'in_progress' then '任務進行中'
    when 'complete' then '任務已完成'
    when 'cancel' then '取消組隊'
    when 'abort' then '任務已放棄'
    end
  end

  def transcript_instance_state(instance)
    case instance.state
    when 'teaming' then '組隊中'
    when 'in_progress' then '進行中'
    when 'complete' then '已完成'
    when 'abort' then '已放棄'
    end
  end

  def enter_instance(instance)
    case instance.state
      when 'teaming'
        link_to "招募探員", instance_path(instance), class: "btn btn-primary"
      when 'in_progress'
        link_to "進行任務", instance_path(instance), class: "btn btn-primary"
      else
        link_to "任務詳情", instance_path(instance), class: "btn btn-primary"
      end
  end

  def user_already_done(instance, user)
    if user.missions_compeleted.include?(instance.mission)
      content_tag(:span, '已完成過' , class: "badge badge-success mb-2")
    end
  end

  def user_in_progress(instance, user)
    if user.missions_in_progress.include?(instance.mission)
      content_tag(:span, '正執行中' , class: "badge badge-success mb-2")
    end
  end

  def user_already_decline(instance, user)
    if user.was_declined?(instance)
      content_tag(:span, '已拒絕' , class: "badge badge-danger mb-2")
    end
  end

  def instance_member_names(instance)
    instance.members.map {|member| member.name }.join(", ")
  end

  def progress_num(instance)
    if instance.state == 'teaming'
      '25'
    elsif instance.state == 'in_progress' && instance.answer == ''
      '50'
    elsif instance.state == 'in_progress' && instance.answer != ''
      '75'
    elsif instance.state == 'complete' && instance.reviews.where(submit: false).present?
      '90'
    elsif instance.state == 'complete'
      '100'
    else
      '0'
    end
  end

  def review_submited?(instance,user)
    reviews = instance.reviews.find_by(reviewer_id: user)
    if reviews.present? && !reviews.submit?
      '尚未給評'
    end
  end



end
