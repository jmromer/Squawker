include FakeFriends

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users_and_posts
    make_relationships
  end
end

def make_users_and_posts
  admin    = FakeFriend.find_by(username: 'idiot')
  jane     = FakeFriend.find_by(username: 'divya')
  friends  = [admin, jane]
  the_rest = FakeFriend.gather(50)

  the_rest.delete_if{|user| ['idiot', 'divya'].include?(user.username) }
  friends += the_rest

  friends.each_with_index do |friend, idx|
    name           = friend.name
    email          = "user#{idx+1}@example.com"
    image_url      = friend.avatar_url(128)
    posts          = friend.posts

    if idx+1 == 1
      name = "Johnny Neckbeard"
    elsif idx+1 == 2
      name = "Jane Squawker"
    end

    user = User.create!( name: name, email: email, image_url: image_url,
                         password: "password", password_confirmation: "password")

    posts.each do |post|
      user.squawks.create!( content: post[:text], created_at: post[:time] )
    end
  end

  User.find(1).update_attribute(:admin, true)
end

def make_relationships
  users     = User.all
  admin     = users[0]
  jane      = users[1]
  followeds = users.shuffle
  followers = users.shuffle

  followers.each do |follower|
    followeds.sample((10..30).to_a.sample).each do |followed|
      follower.follow!(followed) unless followed.id == follower.id
    end
  end

end
