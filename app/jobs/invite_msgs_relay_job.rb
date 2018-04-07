class InviteMsgsRelayJob < ApplicationJob
  queue_as :default

  def perform(invite_msg)
    # Do something later
    message = invite_msg.id
    ActionCable.server.broadcast "invite_msgs_#{invite_msg.invitation.id}_channel", message: message
  end
end
