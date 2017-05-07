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

require "rails_helper"

describe Squawk do
  it { should have_many(:likes) }
  it { should have_many(:likers).through(:likes) }
  it { should validate_presence_of(:likes_count) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:content) }
  it { should validate_length_of(:content).is_at_most(160) }
end
