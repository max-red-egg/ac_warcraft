class AddIndexToDatabase < ActiveRecord::Migration[5.2]
  def change
    add_index :abort_requests, :user_id
    add_index :abort_requests, :instance_id
    add_index :announcements, :author_id
    add_index :followships, [:user_id, :following_id], unique: true
    add_index :instance_msgs, :user_id 
    add_index :instance_msgs, :instance_id
    add_index :instances, :mission_id
    add_index :invitations, :instance_id
    add_index :invitations, :invitee_id
    add_index :invitations, :user_id
    add_index :invite_msgs, :user_id
    add_index :invite_msgs, :invitation_id
    add_index :invite_msgs, :recipient_id
    add_index :notifications, :recipient_id
    add_index :notifications, :actor_id
    add_index :notifications, :notifiable_id
    add_index :recruit_boards, :user_id
    add_index :recruit_boards, :instance_id
    add_index :reviews, :reviewer_id
    add_index :reviews, :reviewee_id
  end
end
