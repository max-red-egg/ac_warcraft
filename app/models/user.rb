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
  has_many :missions, through: :instances


  has_many :invitations
  has_many :invite_msgs

  #user.reviews 所有參與過的任務的評價
  has_many :reviews, foreign_key: "reviewee_id", class_name: "Review"

  #給予其他user的評價
  has_many :review_to_members, foreign_key: "reviewer_id", class_name:"Review"

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

  #所有完成過的任務
  def missions_compeleted
    missions = self.missions.where('instances.state = ? ', 'complete')
  end

  #正在進行中的任務
  def missions_in_progress
    missions = self.missions.where('instances.state = ? ', 'in_progress')
  end

  def was_declined?(instance)
    instance.invitations.where('invitations.invitee_id = ? AND invitations.state = ?', self, 'decline').present?
  end


end
