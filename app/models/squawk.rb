# frozen_string_literal: true

# == Schema Information
#
# Table name: squawks
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#
require "elasticsearch/model"

# Squawk instance methods
class Squawk < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 160 }
  validates :likes_count, presence: true

  before_save :transform_text
  belongs_to :user
  has_many :likes
  has_many :likers, through: :likes

  default_scope -> { order("created_at DESC") }

  private

  def transform_text
    self.content = self.class.squawked_text(content)
  end
end

# Squawk class methods
class Squawk < ActiveRecord::Base
  class << self
    def new_collection_from_tweets(tweets)
      return [nil, []] unless (tweeter = tweets.try(:first).try(:user))

      user = User.new_from_tweeter(tweeter)
      return [nil, []] unless user.save

      squawk_attrs = tweets.pmap do |tweet|
        { user_id: user.id,
          content: squawked_text(tweet.text),
          created_at: tweet.created_at,
          updated_at: tweet.created_at }
      end

      bulk_insert(*squawk_attrs.first.keys) do |worker|
        squawk_attrs.each do |book|
          worker.add(book)
        end
      end

      [user, squawk_attrs]
    end

    def from_users_followed_by(user)
      followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"

      is_followee_or_self = "user_id IN (#{followed_user_ids})
                           OR user_id = :user_id"

      where(is_followee_or_self, user_id: user)
    end

    def squawked_text(st)
      st.partition(/(https?.*)/i)
        .map { |i| i =~ %r{(https?:\/\/.*)}i ? i : i.upcase }
        .join
    end
  end
end

# Auto sync with elasticsearch
begin
  Squawk.import
rescue ArgumentError => e
  Rails.logger.info("Forcing creation of ElasticSearch index")
  Rails.logger.info("Exception: #{e}")
  Squawk.import(force: true)
end
