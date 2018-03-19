class Invitation < ApplicationRecord
  after_commit :setup_state!
  belongs_to :user
  belongs_to :instance
  belongs_to :invitee, class_name: "User"
  #可能要加counter cache
  has_many :invite_msgs

  def time_updated!
    self.updated_at = Time.now
    self.save
  end

  private

  def setup_state!
    if self.state == 'accept' && !instance.is_member?(self.invitee)
      #join invitee into instance
      instance.members << invitee

      #要save才會呼叫after_commit
      instance.save
    end
  end
end
