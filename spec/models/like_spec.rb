# frozen_string_literal: true

require "rails_helper"

RSpec.describe Like, type: :model do
  it { should belong_to(:liker) }
  it { should belong_to(:liked_squawk) }
  it { should validate_presence_of(:liker) }
  it { should validate_presence_of(:liked_squawk) }
end
