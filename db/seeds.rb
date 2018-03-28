# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# file = File.open("#{Rails.root}/public/avatar/mre.jpg")
User.create(name:'Mr.E', 
  email:'admin@admin.com', 
  password:'password', 
  level: 15,
  description:'This is Mr.E',
  role:'admin',
  # avatar: file,
  confirmed_at: Time.zone.now )