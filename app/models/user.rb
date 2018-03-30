class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable

  mount_uploader :avatar, AvatarUploader

  #user_instance為 user與instance之間的關係
  has_many :user_instances

  #每次接受一個任務，就會產生一個副本instance,等人數符合後，instance的狀態會改成in_progress
  #user.instances可以看到所有挑戰過的副本
  has_many :instances, through: :user_instances
  has_many :missions, through: :instances


  has_many :invitations
  has_many :invite_msgs

  #user.reviews 所有參與過的任務的評價
  has_many :reviews, foreign_key: "reviewee_id", class_name: "Review"

  has_many :notifications, foreign_key: :recipient_id

  #給予其他user的評價
  has_many :review_to_members, foreign_key: "reviewer_id", class_name:"Review"

  has_many :followships, dependent: :destroy#外鍵預設為user_id
  has_many :followings, through: :followships#有很多自己追蹤的user

  has_many :inverse_followships, class_name: "Followship", foreign_key: :following_id
  has_many :followers, through: :inverse_followships, source: :user # 從inverse_followships表裡面的user欄位去找
  has_many :recruit_boards

  filterrific(
    default_filter_params: {
      sorted_by: 'name_asc',
    },
    available_filters: [
      :sorted_by,
      :search_query,
      :with_gender,
      :with_oldfriend,
      :range_level
    ]
  )
  scope :can_be_invited, ->(instance){
    where('level >= ? AND available = ?',instance.mission.level,true
      ).where.not(
        id: User.joins(:user_instances).where('user_instances.instance_id = ? ',instance.id)
      ).where.not(
        id: User.joins('JOIN invitations ON invitations.invitee_id = users.id').where('invitations.instance_id = ? AND invitations.state = ?',instance.id,'inviting')
      )
  }

  scope :search_query, lambda { |query|
    return nil  if query.blank?
    # condition query, parse into individual keywords
    terms = query.downcase.split(/\s+/)
    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    terms = terms.map { |e|
      (e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    # configure number of OR conditions for provision
    # of interpolation arguments. Adjust this if you
    # change the number of OR conditions.
    num_or_conditions = 2
    where(
      terms.map {
        or_clauses = [
          "LOWER(users.name) LIKE ?",
          "LOWER(users.email) LIKE ?"
        ].join(' OR ')
        "(#{ or_clauses })"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conditions }.flatten
    )
  }

  scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^created_at_/
      order("users.created_at #{ direction }")
    when /^name_/
      order("LOWER(users.name) #{ direction }")
    when /^level_/
      order("users.level #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  scope :with_gender, lambda { |genders|
    where(gender: [*genders])
  }

  scope :with_oldfriend, lambda { |boolean|
    if boolean == true # 待完成
      where()
    else
      whrer()
    end
  }

  # always include the lower boundary for semi open intervals
  scope :range_level, lambda { |level|
    where('users.level >= ? AND users.level < ?', level , level+5)
  }

  def self.options_for_sorted_by
    [
      ['Name (a-z)', 'name_asc'],
      ['Name (z-a)', 'name_desc'],
      ['Level (a-z)', 'level_asc'],
      ['Level (z-a)', 'level_desc'],
      ['Registration date (newest first)', 'created_at_desc'],
      ['Registration date (oldest first)', 'created_at_asc']
    ]
  end

  def add_xp(xp)
    self.xp += xp
    self.level = self.xp / 1000
    if self.level == 0
      self.level =1 
    end
    self.save!
  end

  def admin?
    self.role == 'admin'
  end

  # 確認該任務可不可以執行
  def take_mission?(mission)
    self.level >= mission.level && not_in_banned_mission_list(mission)
  end

  # 是否有被user評論過instance副本？
  def be_reviewed_from?(user,instance)
    user_instance = self.user_instances.find_by(instance_id: instance.id)
    user_instance.reviewers.include?(user)
  end

  # 尚未給的評論數
  def unsubmited_review_count
    self.review_to_members.where(submit: false).count
  end

  #所有完成過的任務
  def missions_compeleted
    missions = self.missions.where('instances.state = ? ', 'complete')
  end

  #正在進行中的任務
  def missions_in_progress
    missions = self.missions.where('instances.state = ? ', 'in_progress')
  end

  #正在進行中的副本
  def instances_in_progress
    instances = self.instances.where(state: 'in_progress')
  end

  #正在進行中的副本
  def instances_teaming
    instances = self.instances.where(state: 'teaming')
  end

  def was_declined?(instance)
    instance.invitations.where('invitations.invitee_id = ? AND invitations.state = ?', self, 'decline').present?
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end

  def set_average_rating_count!
    total_rating = reviews.submited.inject(0){|sum,review|sum + review.rating}
    if(reviews.submited.count > 0)
      self.average_rating_count = (total_rating.to_f / reviews.submited.count.to_f).round(1)
    else
      self.average_rating_count = 0
    end
    self.save
  end



  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      # binding.pry
      user.name = auth.info.name ? auth.info.name : auth.info.nickname
      user.email = auth.info.email
      user.confirmed_at = Time.zone.now
      user.password = Devise.friendly_token[0,20]
    end
  end

  private

  def not_in_banned_mission_list(mission)
    # 先找出正在進行中或組隊中的副本
    in_progress_instances = self.instances.select do |instance|
      instance.state == 'in_progress' || instance.state == 'teaming'
    end.uniq
    # binding.pry
    # 從正在進行的副本中找出自己發起的副本
    self_initiated_instances = in_progress_instances.select do |instance|
      initiate_user = UserInstance.where(instance_id: instance.id).order(created_at: :desc)[0].user
      # 如果自己是任務發起人的話此任務會被挑選出來
      self == initiate_user
    end
    banned_missions = self_initiated_instances.map { |instance| instance.mission }.uniq
    !banned_missions.include?(mission)
  end

end
