module InvitationsHelper

  def cross_invite_badges(invitation)

    mission = invitation.instance.mission
    missions = mission.invitations.where('invitations.user_id = ? AND invitations.invitee_id = ? AND invitations.state = ?', invitation.invitee, invitation.user ,'inviting')

    if missions.present? && invitation.state == 'inviting'
       content_tag(:span, '同任務互邀中' , class: "badge badge-info ml-1")
    end

  end

end
