class Instance < ApplicationRecord
  after_commit :setup_state!
  has_many :user_instances, dependent: :destroy

  #instance.members 表示此副本的所有成員
  has_many :members, through: :user_instances, source: :user

  #instance.mission 表示本隊的任務
  belongs_to :mission


  def complete!
    #任務完成，更改狀態
    if self.state == 'in_progress'
      self.state = 'complete'
      self.save
      #更改所有member狀態
      members = self.members
      members.each do |member|
        member.available = 'yes'
        member.save
      end
    end
  end

  def abort!
    if self.state == 'in_progress' || self.state == 'teaming'
      self.state = 'abort'
      self.save
      #更改所有member狀態
      members = self.members
      members.each do |member|
        member.available = 'yes'
        member.save
      end
    end
  end

  def is_member?(user)
    members.include?(user)
  end

  private
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
