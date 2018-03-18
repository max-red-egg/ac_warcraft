class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  mount_uploader :avatar, AvatarUploader
  
  #user_instance為 user與instance之間的關係
  has_many :user_instances
  
  #每次接受一個任務，就會產生一個副本instance,等人數符合後，instance的狀態會改成in_progress
  #user.instances可以看到所有挑戰過的副本
  has_many :instances, through: :user_instances

  has_many :invitations
  has_many :invite_msgs
 


  def admin?
    self.role == 'admin'
  end

  # 確認該任務可不可以執行
  def take_mission?(mission)
    #(self.available == 'yes') && (self.level >= mission.level)
    #註解掉, 如果打開，則user available會影響是否可以直接挑戰任務
    self.level >= mission.level
  end
end
