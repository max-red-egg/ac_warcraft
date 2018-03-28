namespace :dev do
  task fake_user: :environment do
    User.destroy_all
    20.times do |i|

      # file = File.open("#{Rails.root}/public/avatar/user#{i+1}.jpg")
      User.create!(
        email: (User.count+1).to_s+".user@gmail.com",
        password:"12345678",
        name: FFaker::Name.first_name,
        level: rand(15)+1,
        gender: FFaker::Gender.random,
        description:FFaker::Lorem.paragraph,
        # avatar: file,
        confirmed_at: Time.zone.now
        )
    end
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
    Mission.all.each do |mission|
        mission.xp = Random.rand(200..600)
        mission.save
    end
    User.all.each do |user|
        user.xp = user.level * 1000
        user.save
    end
    puts 'generated fake xp for missions and users!'
  end

  task fake_instances: :environment do
    Instance.destroy_all
    User.all.each do |user|
        3.times do 
          mission = Mission.all.sample
          instance = user.instances.create(mission_id: mission.id)
          instance.xp = mission.xp 
          instance.save
        end
    end
    puts "create #{Instance.count} fake instances"
    puts "Now you have #{Instance.count} instances!"
  end
  
  task fake_mission_tag: :environment do
    missions = Mission.all
    list = ['Rails, Ruby','JavaScript, CSS','python','node.js','HTML, CSS','JavaScript', 'node.js, vue.js','php','php, css']
    missions.each do |mission|
      mission.tag_list = list.sample
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
end
