# frozen_string_literal: true

require "rails_helper"

RSpec.describe Like, type: :model do
  it { is_expected.to belong_to(:liker) }
  it { is_expected.to belong_to(:liked_squawk) }
  it { is_expected.to validate_presence_of(:liker) }
  it { is_expected.to validate_presence_of(:liked_squawk) }
end
