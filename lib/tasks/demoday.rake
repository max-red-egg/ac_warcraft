namespace :demoday do
  task fake_user_a: :environment do
    old_user = User.find_by(email:'shizuka@sample.com')
    #刪除user A所有參與過的 instance 
    #其中instance的review,  invite_msg, invitations, 通知
    if old_user 
      old_user.instances.each do |instance|
        instance.invitations.delete_all
        instance.instance_msgs.delete_all
        instance.reviews.delete_all
        puts "instance id #{instance.id} has removed"
        instance.delete
      end
      puts "now old_user has #{old_user.instances.count} instances"
      Notification.where(recipient: old_user).delete_all
      Notification.where(actor: old_user).delete_all
      old_user.delete
    end

    ##產生新user a
    file =  File.open("#{Rails.root}/public/avatar/usera.jpg")
    fake_users = User.where("email LIKE '%user@sample.com'")
    new_user = User.create!(
      email: "shizuka@sample.com",
      password:"12345678",
      level: 14,
      name: "靜香",
      description:"我是暗網局局長的女兒呦～啾咪",
      avatar: file,
      confirmed_at: Time.zone.now
    )
    fake_reviews = [{rating: 5,
      comment: "hen 棒！"
      },{
      rating: 5,
      comment: "整場都在cover我，不給五顆說不過去"
      },{
      rating: 5,
      comment: "太強了"
      },{
      rating: 5,
      comment: "都會用一些很神的寫法，效能也不錯，大推神隊友"
      },{
      rating: 5,
      comment: "秒解！大神受我一拜！"
      },{
      rating: 5,
      comment: "開心的一場戰役！"
      },{
      rating: 5,
      comment: "太神的隊友，大家不要跟我搶"
      }]
    for i in 1..10
      email = "#{i}.user@sample.com"
      fake_review = fake_reviews.sample
      team_mate = User.find_by(email: email)
      mission = Mission.where('participant_number >= ? AND level <= ?', 2,team_mate.level).sample
      members = [new_user,team_mate]
      instance = mission.instances.build(state: 'teaming', answer:FFaker::Lorem.sentence, xp: mission.xp)
      instance.members << members
      instance.save
      instance.complete!(instance.members[0])
      puts "generate instance #{instance.mission.name}"
      instance.reviews.find_by(reviewee_id: team_mate.id).update(rating:4,submit: true, comment:"不錯喔！")
      instance.reviews.find_by(reviewee_id: new_user.id).update(rating: fake_review[:rating], submit: true,comment: fake_review[:comment])
      #puts "完成了任務#{mission.id}"
    end
    new_user.xp = 17520
    new_user.level = 17
    new_user.save
  end

  task fake_user_b: :environment do
    old_user = User.find_by(email:'goda@sample.com')
    #刪除user A所有參與過的 instance 
    #其中instance的review,  invite_msg, invitations, 通知
    if old_user 
      old_user.instances.each do |instance|
        instance.invitations.delete_all
        instance.instance_msgs.delete_all
        instance.reviews.delete_all
        puts "instance id #{instance.id} has removed"
        instance.delete
      end
      puts "now old_user has #{old_user.instances.count} instances"
      Notification.where(recipient: old_user).delete_all
      Notification.where(actor: old_user).delete_all
      old_user.delete
    end

    ##產生新user
    file =  File.open("#{Rails.root}/public/avatar/userb.jpg")
    fake_users = User.where("email LIKE '%user@sample.com'")
    new_user = User.create!(
      email: "goda@sample.com",
      password:"12345678",
      level: 14,
      name: "胖虎",
      description:"我4孩紙王",
      avatar: file,
      confirmed_at: Time.zone.now
    )
    fake_reviews = [{rating: 1,
      comment: "不知道在幹嘛"
      },{
      rating: 2,
      comment: "很勉強才可以給到兩顆"
      },{
      rating: 1,
      comment: "超沒品的"
      },{
      rating: 2,
      comment: "無言的隊友"
      }]
    for i in 1..4
      email = "#{i}.user@sample.com"
      #fake_review = fake_reviews.sample
      team_mate = User.find_by(email: email)
      mission = Mission.where('participant_number >= ? AND level <= ?', 2,team_mate.level).sample
      members = [new_user,team_mate]
      instance = mission.instances.build(state: 'teaming', answer:FFaker::Lorem.sentence, xp: mission.xp)
      instance.members << members
      instance.save
      instance.complete!(instance.members[0])
      puts "generate instance #{instance.mission.name}"
      instance.reviews.find_by(reviewee_id: team_mate.id).update(rating:4,submit: true, comment:"不錯喔！")
      instance.reviews.find_by(reviewee_id: new_user.id).update(rating: fake_reviews[i-1][:rating], submit: true,comment: fake_reviews[i-1][:comment])
      #puts "完成了任務#{mission.id}"
    end
  end
end
