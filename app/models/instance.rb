class Instance < ApplicationRecord
  after_commit :setup_state
  has_many :user_instances, dependent: :destroy

  #instance.members 表示此副本的所有成員
  has_many :members, through: :user_instances, source: :user

  #instance.mission 表示本隊的任務
  belongs_to :mission

  private
  def setup_state
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
