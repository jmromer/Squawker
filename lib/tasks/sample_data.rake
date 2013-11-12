namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_squawks
    make_relationships
  end
end

def make_users
  admin = User.create!(name:     "Admin User",
                       email:    "admin@example.com",
                       password: "password",
                       password_confirmation: "password",
                       admin: true)
  jane  = User.create!(name:     "Jane Squawker",
                       email:    "jane@squawker.com",
                       password: "password",
                       password_confirmation: "password",
                       admin: false)
  98.times do |n|
    name  = Faker::Name.name
    email = "user-#{n+1}@example.com"
    password  = "password"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_squawks
  users = User.all(limit: 6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.squawks.create!(content: content) }
  end
end

def make_relationships
  users = User.all
  user  = users.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end