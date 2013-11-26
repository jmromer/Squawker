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

class Squawk < ActiveRecord::Base
  validates   :user_id, presence: true
  validates   :content, presence: true, length: { maximum: 160 }
  before_save :transform_text

  belongs_to :user
  default_scope -> { order ('created_at DESC') }

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"

    is_followee_or_self = "user_id IN (#{followed_user_ids})
                           OR user_id = :user_id"

    where(is_followee_or_self, user_id: user)
  end

  private
    def transform_text
      self.content =
        self.content.partition(/(https?.*)/i)
        .map{ |i| (i =~ /(https?:\/\/.*)/i).nil? ? i.upcase : i }.join
    end
end
