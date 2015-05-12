namespace :db do
  desc 'Fill database with sample data'
  task populate: :environment do
    clear_current_rows
    make_users_and_posts
    make_relationships
  end
end

def clear_current_rows
  User.delete_all
  Squawk.delete_all
  Relationship.delete_all
end

def set_name(friend, index)
  if index + 1 == 1
    'Johnny Neckbeard'
  elsif index + 1 == 2
    'Jane Squawker'
  else
    friend.name
  end
end

def create_user_from(friend, index)
  User.create!(
    name: set_name(friend, index),
    email: "user#{index + 1}@example.com",
    image_url: friend.avatar_url(128),
    password: 'password',
    password_confirmation: 'password'
  )
end

def create_user_and_associated_posts(friend, index)
  user = create_user_from(friend, index)
  posts = friend.posts.map do |post|
    { content: post[:text], created_at: post[:time] }
  end
  user.squawks.create!(posts)
end

def make_users_and_posts
  admin   = FakeFriends::FakeFriend.find_by(username: 'idiot')
  jane    = FakeFriends::FakeFriend.find_by(username: 'divya')
  friends = FakeFriends::FakeFriend.gather(50)

  friends.delete_if { |ff| ff.username =~ /idiot|divya/ }
  friends.unshift(admin, jane)

  friends.each_with_index do |friend, idx|
    create_user_and_associated_posts(friend, idx)
  end

  User.find(1).update_attribute(:admin, true)
end

def make_relationships
  users     = User.all
  followeds = users.shuffle
  followers = users.shuffle

  followers.each do |follower|
    followeds.sample((10..30).to_a.sample).each do |followed|
      next if followed.id == follower.id
      follower.follow!(followed)
    end
  end
end
