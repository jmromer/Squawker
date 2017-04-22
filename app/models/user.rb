# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  email                :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  password_digest      :string(255)
#  remember_token       :string(255)
#  admin                :boolean          default(FALSE)
#  password_reset_token :string(255)
#  password_reset_at    :datetime
#  image_url            :string(255)
#
class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  before_create :create_tokens

  validates :name, presence: true, length: { maximum: 50 }
  validates :username,
            presence: true,
            length: { maximum: 50 },
            uniqueness: { case_sensitive: false }

  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-\.]+[^\.]\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL },
                    uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  validates :remember_token, uniqueness: true
  validates :password_reset_token, uniqueness: true

  # provides presence validation, password and password_confirmation attributes,
  # and matching validation for those two
  has_secure_password

  has_many :squawks, dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :followers, through: :reverse_relationships, source: :follower

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_relationships,
           foreign_key: "followed_id",
           class_name: "Relationship",
           dependent: :destroy

  self.per_page = 20

  def send_password_reset
    self.password_reset_token = User.new_token
    self.password_reset_at    = Time.zone.now
    save!(validate: false)
    UserMailer.password_reset(self).deliver
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    Squawk.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy!
  end

  def dummy?
    email !~ /.+@example.com$/
  end

  def to_param
    username
  end

  private

  def create_tokens
    self.remember_token       = User.encrypt(User.new_token)
    self.password_reset_token = User.new_token
  end
end
