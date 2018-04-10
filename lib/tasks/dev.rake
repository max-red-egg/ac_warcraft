namespace :dev do
  task fake_user: :environment do
    User.destroy_all
    20.times do |i|

      file = File.open("#{Rails.root}/public/avatar/user#{i+1}.jpg")
      User.create!(
        email: (User.count+1).to_s+".user@sample.com",
        password:"12345678",
        name: FFaker::Name.first_name,
        level: rand(15)+1,
        gender: FFaker::Gender.random,
        description:FFaker::Lorem.paragraph,
        avatar: file,
        confirmed_at: Time.zone.now
        )
    end
    system('rails db:seed')
    puts "create #{User.count} fake users"
    puts "Now you have #{User.count} users!"
  end

  task fake_xp: :environment do
    User.all.each do |user|
        user.xp = user.level * 1000
        user.save
    end
    puts 'generated fake xp for users!'
  end

  task fake_instances: :environment do
    Instance.destroy_all
    Review.destroy_all
    Mission.where('participant_number >= ? ', 2).each do |mission|
      3.times do
       members = User.where('level >= ?', mission.level).sample(2)
       instance = mission.instances.build(state: 'teaming', answer:FFaker::Lorem.sentence, xp: mission.xp)
       instance.members << members
       instance.save
       instance.complete!(instance.members[0])
       puts "generate instance #{instance.mission.name}"
       instance.reviews.each do |review|
        review.update!(rating: rand(1..5),submit: true, comment:FFaker::Lorem.sentence)
        puts "#{review.reviewer.name} give #{review.reviewee.name} #{review.rating} star"
       end
      end
    end
  end

  task fake_followships: :environment do
    Followship.destroy_all

    User.all.each do |user|
      5.times do
        user.followships.create(following_id: User.all.sample.id)
      end
    end
    puts "have created 100 fake follow"
  end

  task reset_average_rating: :environment do
    User.all.each do |user|
      user.set_average_rating_count!
      puts "#{user.name} : #{user.average_rating_count}"
    end
  end

  task reset_instances_count_user: :environment do
    User.all.each do |user|
      user.update_instances_completed_count!
      user.instances_count = user.instances.count
      puts "#{user.name} : #{user.instances_completed_count}: #{user.instances_count}"
    end
  end

  task reset_instances_count_mission: :environment do
    Mission.all.each do |mission|
      mission.instances_count = mission.instances.count
      puts "#{mission.name} : #{mission.instances_count}"
    end
  end

  task reset_invite_msg_recipient: :environment do
    Invitation.all.each do |invitation|
      invite_msgs = invitation.invite_msgs
      inviter = invitation.user
      invitee = invitation.invitee
      invite_msgs.each do |msg|
        if msg.user == inviter
          msg.recipient = invitee
        else
          msg.recipient = inviter
        end
        msg.save
        puts "invite_msg id = #{msg.id}, content = #{msg.content}, user_id = #{msg.user_id}, recipient_id #{msg.recipient_id}"
      end

      puts "inviter : #{inviter.name}. invitee : #{invitee.name}"
    end
  end

  task fake_all: :environment do
    system 'rails db:reset' if Rails.env == 'development'
    system 'rails db:migrate'
    system 'rails dev:fake_user'
    system 'rails mission:mission_fake'
    system 'rails dev:fake_xp'
    system 'rails dev:fake_instances'
    system 'rails dev:fake_followships'
    system 'rails dev:reset_average_rating'
    system 'rails dev:reset_instances_count_user'
    system 'rails dev:reset_instances_count_mission'
    system 'rails dev:reset_invite_msg_recipient'
  end

end
