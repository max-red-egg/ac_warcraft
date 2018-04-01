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

  has_many :announcements, foreign_key: "author_id"

  scope :ordered_by_xp, ->{ order(xp: :desc) }

  scope :can_be_invited, ->(instance){
    where('level >= ? AND available = ?',instance.mission.level,true
      ).where.not(
        id: User.joins(:user_instances).where('user_instances.instance_id = ? ',instance.id)
      ).where.not(
        id: User.joins('JOIN invitations ON invitations.invitee_id = users.id').where('invitations.instance_id = ? AND invitations.state = ?',instance.id,'inviting')
      )
  }

  filterrific(
    default_filter_params: {
      sorted_by: 'name_asc',
    },
    available_filters: [
      :sorted_by,
      :search_query,
      :with_gender,
      :with_followtype,
      :with_level
    ]
  )

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
    when /^name_/
      order("LOWER(users.name) #{ direction }")
    when /^level_/
      order("users.level #{ direction }")
    when /^average_rating_/
      order("users.average_rating_count #{ direction }")
    when /^followers_count_/
      order("users.followers_count #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end

  }

  scope :with_gender, lambda { |genders|
    where(gender: [*genders])
  }

  scope :with_followtype, lambda { |followtype|

    user_id = followtype.split("_")[0]
    type = followtype.split("_")[1]

    if type == 'following'
      where(
        id: User.joins(:followships).where('followships.user_id = ? ', user_id ).select(:following_id)
      )
    elsif type == 'follower'
      where(
        id: User.joins(:followships).where('followships.following_id = ? ', user_id ).select(:user_id)
      )
    else
    end
  }

  # always include the lower boundary for semi open intervals
  scope :with_level, lambda { |level|
    where('users.level >= ? AND users.level <= ?', level-2 , level+2)
  }

  def self.options_for_gender
    [
      ['男', 'male'],
      ['女', 'female']
    ]
  end

  def self.options_for_level

    [
      ['1-5', '3'],
      ['6-10', '8'],
      ['11-15', '13'],
      ['16-20', '18'],
    ]
  end

  def self.options_for_sorted_by
    [
      ['名字 正序', 'name_asc'],
      ['名字 反序', 'name_desc'],
      ['等級 高', 'level_desc'],
      ['等級 低', 'level_asc'],
      ['評價 高', 'average_rating_desc'],
      ['評價 低', 'average_rating_asc'],
      ['追蹤者 多', 'followers_count_desc'],
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
    self.level >= mission.level
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
      user.github_username = auth.info.nickname
      user.email = auth.info.email
      user.confirmed_at = Time.zone.now
      user.password = Devise.friendly_token[0,20]
    end
  end

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


  def update_instances_completed_count!
    self.instances_completed_count = self.instances.find_complete.count
    self.save
  end


  # 拿repos的名字與網址
  def github_repos
    user = Octokit.user "#{self.github_username}"
    repos = user.rels[:repos].get.data.sort_by { |repo| repo.updated_at }.reverse
    repo_names = repos.map { |repo| repo.name }
    repo_urls = repos.map { |repo| repo.html_url }
    repo_names.zip(repo_urls)
  end
  # 確認此user是用github登入
  def have_github_username?
    self.github_username
  end
  # 拿user的github網址
  def github_url
    user = Octokit.user "#{self.github_username}"
    user.html_url
  end
  # 算user的repo數量
  def github_repos_count
    user = Octokit.user "#{self.github_username}"
    repos = user.rels[:repos].get.data
    repos.count
  end


end
