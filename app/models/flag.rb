# frozen_string_literal: true

class Flag < ActiveRecord::Base
  belongs_to :flagger,
             class_name: "User",
             foreign_key: :user_id,
             counter_cache: true

  belongs_to :flagged_squawk,
             class_name: "Squawk",
             foreign_key: :squawk_id,
             counter_cache: true

  validates :flagger, presence: true
  validates :flagged_squawk, presence: true
end
