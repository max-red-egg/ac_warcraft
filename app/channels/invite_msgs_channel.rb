class InviteMsgsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "invite_msgs_#{params['invitation_id']}_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
