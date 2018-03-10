namespace :dev do 
  task fake_user: :environment do 
    User.destroy_all
    20.times do |i|
      
      file = File.open("#{Rails.root}/public/avatar/user#{i+1}.jpg")
      User.create!(
        email: (User.count+1).to_s+".user@gmail.com",
        password:"12345678",
        name: FFaker::Name.first_name,
        level: rand(15)+1,
        gender: FFaker::Gender.random,
        description:FFaker::Lorem.paragraph,
        avatar: file
        )
    end
    puts "create 30 fake user"
    puts "Now you have #{User.count} users!"
  end
end
