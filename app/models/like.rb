## frozen_string_literal: true

class Like < ActiveRecord::Base
  belongs_to :liker,
             class_name: "User",
             foreign_key: :user_id

  belongs_to :liked_squawk,
             class_name: "Squawk",
             foreign_key: :squawk_id

  validates :liker, presence: true
  validates :liked_squawk, presence: true
end
