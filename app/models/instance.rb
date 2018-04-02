class Instance < ApplicationRecord
  after_commit :setup_state!
  after_commit :create_notifications
  has_many :user_instances, dependent: :destroy

  #instance.members 表示此副本的所有成員
  has_many :members, through: :user_instances, source: :user

  #instance.mission 表示本隊的任務
  belongs_to :mission, counter_cache: true

  has_many :invitations
  has_many :invitees, through: :invitations

  has_many :instance_msgs

  has_many :reviews

  belongs_to :modifier, class_name: "User", optional: true

  scope :find_complete ,-> {
    where(state: 'complete')
  }

  def update_answer!(ans_params,user)
    self.update!(answer: ans_params[:answer], modifier: user)
  end


  # ::instance method:: 任務副本instance完成
  def complete!(user)
    #任務完成，更改狀態
    if self.state == 'in_progress'
      self.state = 'complete'
      self.modifier = user  #觸發的使用者
      self.save
      # binding.pry
      # 產生所有隊員的reivew
      self.members.each do |reviewee|
        self.members.each do |reviewer|
          if reviewee != reviewer
            new_review = reviewee.reviews.build(instance_id: self.id)
            new_review.reviewer = reviewer
            new_review.save
          end
        end
      end

      self.members.each do |member|
        # 更新xp
        member.add_xp(self.xp)
        puts "member #{member.name} add xp #{self.xp}"
        member.save
        # 更新complete count
        member.update_instances_completed_count!
      end


    end
  end

  def cancel!
    if self.state == 'teaming'
      self.state = 'cancel'
      self.save

      #取消所有人的邀請函
      self.invitations.find_inviting.each do |invitation|
        invitation.cancel!
        invitation.send_cancel_msg
      end
    end
  end


  # ::instance method::  任務副本instance終止
  def abort!(user)
    if self.state == 'in_progress'
      self.state = 'abort'
      self.modifier = user  #觸發的使用者
      self.save

      # 產生所有隊員的reivew
      self.members.each do |reviewee| 
        self.members.each do |reviewer|
          if reviewee != reviewer
            new_review = reviewee.reviews.build(instance_id: self.id)
            new_review.reviewer = reviewer
            new_review.save
          end
        end
      end
    end
  end


  # ::instance method:: 確認user為instance的成員
  def is_member?(user)
    members.include?(user)
  end

  # ::instance method:: 確認user可被邀請？
  def can_invite?(user)
    # ----說明----
    # 確認是否還有足夠的邀請函可以發送
    # 確認user為可接受邀本任務
    # 確認user不是 邀請中的使用者
    # 確認user不是member
    # ------------
    # 如果user可以接受任務
    # binding.pry
    if self.remaining_invitations_count <= 0
      #如果沒有邀請函可以發送，則不能邀請該user
      return false
    elsif user.take_mission?(self.mission)
      # user不在 邀請函是inviting 的集合中 且不是member, 就是可發送邀請
      return ( !self.invitees.where('invitations.state = ?','inviting').include?(user) ) &&  ( !self.members.include?(user) )
    else
      return false
    end
  end

  # ::instance method:: 列出所有可被邀請的使用者
  def invitable_users
    # ----說明----
    # 可邀請的user = 所有可執行user- 被邀請中的user - members
    # ------------
    users = User.where('available = ? AND level >= ?',true,self.mission.level )
    users = users - self.invitees.where('invitations.state = ?','inviting') - self.members
  end

  # ::instance method:: 列出所有發送邀請中的使用者
  def inviting_users
    self.invitees.where('invitations.state = ?','inviting')
  end

  # ::instance method:: 列出所有發送邀請中的邀請函
  def inviting_invitations
    self.invitations.where('state = ?', 'inviting')
  end
  # ::instance method:: 是否還有邀請函可以發送
  def remaining_invitations_count
    self.mission.invitation_number - self.inviting_invitations.count
  end

  def recipients
    # in_progress 有 save和沒save的狀況：
    #   save:除了自己的所有人
    # abort 
    #   除了自己的所有人
    # complete
    #   所有人
    return_recipients = []
    return_recipients += self.members
    case self.state
    when 'in_progress'
      if self.modifier
        return_recipients.delete(self.modifier)
      end
    when 'abort'
      return_recipients.delete(self.modifier)
    end

    return_recipients
  end

  def actor
    # in_progress 有 save和沒save的狀況
    #  save: modifier
    # abort: modifier
    # complete: modifier
    if(self.modifier)
      return_actor = modifier
    else
      return_actor = User.find_by(email: 'admin@admin.com')
    end
    return_actor
  end

  def create_notifications
    # 通知
    # in_progress 有 save和沒save的狀況
    # abort 
    # complete
    action = self.state
    if action == 'in_progress' ||action == 'abort' || action == 'complete'
      if self.modifier && action == 'in_progress' # save的狀況
        action = 'update_answer'
      end
      if self.members.count >1 
        recipients.each do |recipient|
          Notification.create(recipient: recipient, actor: actor,
            action: action, notifiable: self)
        end
      end
    end
  end
  private
  # ::instance method:: 自動設定任務副本instance狀態
  def setup_state!
    #如果人數滿，組隊中會變成進行中

    #如果設定在after_commit 會造成查詢次數過多
    #這裡要想一下怎麼改會比較好
    # binding.pry
    if self.state == 'teaming'
    # 如果是人數已經滿了，則副本開始
      if self.members.length == self.mission.participant_number
        self.state = 'in_progress'
        self.save
        # 副本開始，其他邀請函取消
        # invitation.cancel inviting
        self.invitations.find_inviting.each do |invitation|
          invitation.cancel!
          invitation.send_cancel_msg
        end
      end
    end
  end


end
