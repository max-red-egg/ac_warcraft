class Instance < ApplicationRecord
  after_commit :setup_state!
  has_many :user_instances, dependent: :destroy

  #instance.members 表示此副本的所有成員
  has_many :members, through: :user_instances, source: :user

  #instance.mission 表示本隊的任務
  belongs_to :mission

  has_many :invitations
  has_many :invitees, through: :invitations

  has_many :instance_msgs

  has_many :reviews, through: :user_instances


  # ::instance method:: 任務副本instance完成
  def complete!
    #任務完成，更改狀態
    if self.state == 'in_progress'
      self.state = 'complete'
      self.save
    end
  end

  # ::instance method::  任務副本instance終止
  def abort!
    if self.state == 'in_progress' || self.state == 'teaming'
      self.state = 'abort'
      self.save
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

  private
  # ::instance method:: 自動設定任務副本instance狀態
  def setup_state!
    #如果人數滿，組隊中會變成進行中

    #如果設定在after_commit 會造成查詢次數過多
    #這裡要想一下怎麼改會比較好
    if self.state == 'teaming'
      if self.members.length == self.mission.participant_number
        self.state = 'in_progress'
        self.save
      end
    end
  end



end
