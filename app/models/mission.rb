class Mission < ApplicationRecord
  mount_uploader :image, MissionImageUploader
  acts_as_taggable
  #mission.instances 可以列出所有本任務產生的副本
  has_many :instances
  has_many :invitations, through: :instances

  filterrific(
    default_filter_params: {
      sorted_by: 'level_desc',
    },
    available_filters: [
      :sorted_by,
      :with_tag
    ]
  )

  scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^level_/
      order("missions.level #{ direction }")
    when /^xp_/
      order("missions.xp #{ direction }")
    when /^created_at_/
      order("missions.created_at #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end

  }

  scope :with_tag, lambda { |tag|
    Mission.tagged_with(tag)
  }

  def self.options_for_sorted_by
    [
      ['等級 高至低', 'level_desc'],
      ['等級 低至高', 'level_asc'],
      ['XP 高至低', 'xp_desc'],
      ['XP 低至高', 'xp_asc'],
      ['新任務優先', 'created_at_desc']
    ]
  end

  def self.options_for_tag
    tags = Mission.tag_counts_on(:tags).map {|tag| tag.name }
  end
end
