require_relative './profile_pics.rb'

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_squawks
    make_relationships
  end
end

def make_users
  admin = User.create!( name:     "Johnny Neckbeard",
                        email:    "admin@example.com",
                        password: "password",
                        password_confirmation: "password",
                        image_url: PROFILE_PICS[0],
                        admin: true )

  jane  = User.create!( name:     "Jane Squawker",
                        email:    "jane@example.com",
                        password: "password",
                        password_confirmation: "password",
                        image_url: PROFILE_PICS[1] )

  3.upto(100).each do |n|
    first = Faker::Name.first_name
    last  = Faker::Name.last_name

    name     = "#{first} #{last}"
    email    = "user-#{n}@example.com"
    password = "password"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 image_url: PROFILE_PICS[n-1],
                 password_confirmation: password)
  end
end

def make_squawks
  users = User.all(limit: 20)

  30.times do
    for user in users do
      date = (1..30).to_a.sample.days.ago
      dummy_text = Faker::Lorem.sentence(5)
      user.squawks.create!(content: dummy_text, created_at: date)
    end
  end
end

def make_relationships
  users = User.all
  admin = users[0]
  jane  = users[1]

  followed_users = users[1..50]
  followers      = users[1..40]

  followed_users.each do |followed|
    admin.follow!(followed) unless followed.id == admin.id
    jane.follow!(followed)  unless followed.id == jane.id
  end

  followers.each do |follower|
    follower.follow!(admin) unless follower.id == admin.id
    follower.follow!(jane)  unless follower.id == jane.id
  end
end