namespace :dev do
  task fake_user: :environment do
    User.destroy_all
    9.times do |i|
      file = File.open("#{Rails.root}/public/avatar/user#{(1..9).to_a.sample}.jpg")
      User.create!(
        email: (User.count+1).to_s+".user@sample.com",
        password:"12345678",
        name: FFaker::Name.first_name,
        level: rand(15)+1,
        gender: "female",
        description:FFaker::Lorem.paragraph,
        avatar: file,
        confirmed_at: Time.zone.now
        )
    end
    11.times do |i|
      file = File.open("#{Rails.root}/public/avatar/user#{(10..20).to_a.sample}.jpg")
      User.create!(
        email: (User.count+1).to_s+".user@sample.com",
        password:"12345678",
        name: FFaker::Name.first_name,
        level: rand(15)+1,
        gender: "male",
        description:FFaker::Lorem.paragraph,
        avatar: file,
        confirmed_at: Time.zone.now
        )
    end
    system('rails db:seed')
    puts "create #{User.count} fake users"
    puts "Now you have #{User.count} users!"
  end

  task fake_mission: :environment do
    Mission.destroy_all
    50.times do |i|
      file = File.open("#{Rails.root}/public/mission/mission_#{i%12+1}.jpg")
        Mission.create!(
            name: FFaker::Book.title,
            description: FFaker::Book.description,
            level: rand(15)+1,
            image: file,
            invitation_number: 5,
            participant_number: rand(2) + 1
        )
    end
    puts "create #{Mission.count} fake missions"
    puts "Now you have #{Mission.count} missions!"
  end

  task fake_mission_level1: :environment do
    Mission.destroy_all
    50.times do |i|
      file = File.open("#{Rails.root}/public/mission/mission_#{i%12+1}.jpg")
        Mission.create!(
            name: FFaker::Book.title,
            description: FFaker::Book.description,
            level: 1,
            image: file,
            invitation_number: 5,
            participant_number: rand(2) + 1
        )
    end
    puts "create #{Mission.count} fake missions"
    puts "Now you have #{Mission.count} missions!"
  end

  task fake_xp: :environment do
    # Mission.all.each do |mission|
    #     mission.xp = Random.rand(200..600)
    #     mission.save
    # end
    User.all.each do |user|
        user.xp = user.level * 1000
        user.save
    end
    puts 'generated fake xp for missions and users!'
  end

  # task fake_instances: :environment do
  #   binding.pry
  #   Instance.destroy_all

  #   User.all.each do |user|

  #       3.times do 
  #         mission = Mission.all.sample
  #         instance = user.instances.create(mission_id: mission.id)
  #         instance.xp = mission.xp 
  #         instance.save
  #       end
  #   end
  #   puts "create #{Instance.count} fake instances"
  #   puts "Now you have #{Instance.count} instances!"
  # end
  task fake_instances: :environment do 
    Instance.destroy_all
    Review.destroy_all
    fake_reviews = [{
      rating: 1,
      comment: "消失不見也不通知，最後靠我一個人寫"
      },{
      rating: 1,
      comment: "溝通能力有問題"
      },{
      rating: 2,
      comment: "程度需要加強"
      },{
      rating: 2,
      comment: "人很好，但是code有點髒"
      },{
      rating: 2,
      comment: "不能都用暴力法來解啊"
      },{
      rating: 3,
      comment: "還ok啦"
      },{
      rating: 3,
      comment: "雖然寫得很快，但是有時候找不到人"
      },{
      rating: 3,
      comment: "能力不錯，可是不太好溝通"
      },{
      rating: 3,
      comment: "雖然能力不太優，可是是很認真的人"
      },{
      rating: 4,
      comment: "還不錯"
      },{
      rating: 4,
      comment: "愉快的合作！"
      },{
      rating: 4,
      comment: "很厲害喔！"
      },{
      rating: 4,
      comment: "是個很認真的人"
      },{
      rating: 4,
      comment: "Good!"
      },{
      rating: 5,
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
    Mission.where('participant_number >= ? ', 2).each do |mission|
      3.times do
        fake_review = fake_reviews.sample
        members = User.where('level >= ?', mission.level).sample(2)   
        instance = mission.instances.build(state: 'teaming', answer:FFaker::Lorem.sentence, xp: mission.xp)
        instance.members << members
        instance.save
        instance.complete!(instance.members[0])
        puts "generate instance #{instance.mission.name}"
        instance.reviews.each do |review|
        review.update!(rating: fake_review[:rating],submit: true, comment: fake_review[:comment])
        puts "#{review.reviewer.name} give #{review.reviewee.name} #{review.rating} star"
        end
      end
    end
  end

  task fake_mission_tag: :environment do
    missions = Mission.all
    list = ['Rails, Ruby','JavaScript, CSS','python','node.js','HTML, CSS','JavaScript', 'node.js, vue.js','php','php, css']
    missions.each do |mission|
      mission.tag_list.add(list.sample, parse:true)
      mission.save
      puts mission.tag_list
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

  task reset_instances_count_user: :environment do 
    User.all.each do |user|
      user.update_instances_completed_count!
      user.instances_count = user.instances.count
      puts "#{user.name} : #{user.instances_completed_count}: #{user.instances_count}"
    end
  end

  task fake_all: :environment do
    system 'rails db:reset' if Rails.env == 'development'
    system 'rails db:migrate'
    system 'rails dev:fake_user'
    system 'rails mission:mission_fake'
    system 'rails dev:fake_xp'
    system 'rails dev:fake_instances'
    # system 'rails dev:fake_mission_tag'
    system 'rails dev:fake_followships'
    system 'rails dev:reset_average_rating'
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

  task mission_fake: :environment do
    fake_data = [{
        name: "HTML大霸閣",
        level: 12,
        description: "請解釋「從你在瀏覽器裡輸入 www.facebook.com ，按下 Enter 到你的臉書牆出現在瀏覽器裡」，你的電腦跟 facebook 的伺服器做了什麼溝通？請引用 HTTP，client side vs. server side 等概念，以你知道的，盡可能把步驟描述出來。",
        participant_number: 1,
        xp:200,
        tag: "HTML/CSS, Javascript"
    },{
        name: "HTML大霸閣2",
        level: 2,
        description: "請解釋「從你在瀏覽器裡輸入 www.facebook.com ，按下 Enter 到你的臉書牆出現在瀏覽器裡」，你的電腦跟 facebook 的伺服器做了什麼溝通？請引用 HTTP，client side vs. server side 等概念，以你知道的，盡可能把步驟描述出來。",
        participant_number: 2,
        xp:200,
        tag: "Ruby, Rails"
    }]
    fake_data.each do |newfake|
      mission = Mission.new
      mission.name = newfake[:name]
      mission.level =newfake[:level]
      mission.description = newfake[:description]
      mission.participant_number = newfake[:participant_number]
      mission.invitation_number = 5
      mission.xp = newfake[:xp]
      new_tags = newfake[:tag].split(",").reject { |c| c.empty? }
      mission.tag_list.add(new_tags)
      mission.save
      puts "create mission #{mission.name}"
    end
  end


end
