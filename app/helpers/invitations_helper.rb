module InvitationsHelper

  def cross_invite_badges(invitation)

    if invitation.state == 'inviting'
      mission = invitation.instance.mission
      reverce_invitations = mission.invitations.where('invitations.user_id = ? AND invitations.invitee_id = ? AND invitations.state = ?', invitation.invitee, invitation.user ,'inviting')

      if reverce_invitations.present?
         content_tag(:span, '同任務互邀中' , class: "badge badge-info ml-1")
      end
    end

  end

end
