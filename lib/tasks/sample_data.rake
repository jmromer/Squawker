require_relative './false_friends.rb'

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users_and_tweets
    make_relationships
  end
end

def pull_timeline_for(twitter_username, count)
  # returns array of non-retweeted tweets with name, time, text
  options = { count: count, exclude_replies: true }

  Twitter.user_timeline(twitter_username, options)
         .delete_if{ |t| t.retweeted }
         .delete_if{ |t| t.text =~ /^RT\s@/ }
         .map do |tweet|
           { name: tweet.user.name,
             time: tweet.created_at,
             text: tweet.text }
             end
end

def make_users_and_tweets
  FALSE_FRIENDS[0..50].each_with_index do |username, idx|
    num_of_squawks = (30..50).to_a.sample
    tweets         = pull_timeline_for(username, num_of_squawks)
    name           = tweets.first[:name]
    email          = "user#{idx+1}@example.com"
    base_url       = "#{BASE_URL}/#{username}"

    if idx+1 == 1
      name = "Johnny Neckbeard"
    elsif idx+1 == 2
      name = "Jane Squawker"
    end

    user = User.create!( name: name, email: email, image_url: base_url,
                         password: "password", password_confirmation: "password")

    tweets.each do |tweet|
      user.squawks.create!( content: tweet[:text], created_at: tweet[:time] )
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
