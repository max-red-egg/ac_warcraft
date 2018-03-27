class InstanceMsg < ApplicationRecord
  after_commit :create_notifications
  belongs_to :instance
  belongs_to :user

  def recipients
    #   除了自己的所有人
    return_recipients = []
    return_recipients += self.instance.members
    return_recipients.delete(self.user)
    return_recipients
  end

  def actor
    return_actor = self.user
  end
  def create_notifications
    instance_temp = self.instance
    instance_msgs = instance_temp.instance_msgs
    if instance_msgs.count > 1
      msg_id = instance_msgs.last(2)[0].id
    end
    remove_notifications = Notification.all.where(notifiable_type:"InstanceMsg",notifiable_id: msg_id)
    if remove_notifications
      puts "delete"
      remove_notifications.destroy_all
    end
    recipients.each do |recipient|
      Notification.create(recipient: recipient, actor: actor,
            action: "send_msg", notifiable: self)
    end
  end
end
