# frozen_string_literal: true

# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require "rails_helper"

describe Relationship do
  it { should validate_uniqueness_of(:follower_id).scoped_to(:followed_id) }

  let(:follower) { create(:user) }
  let(:followed) { create(:user) }
  let(:relationship) { follower.relationships.build(followed_id: followed.id) }

  subject { relationship }

  it { should be_valid }

  describe "follower methods" do
    it { should respond_to(:follower) }
    it { should respond_to(:followed) }

    describe "#follower" do
      subject { super().follower }
      it { should eq follower }
    end

    describe "#followed" do
      subject { super().followed }
      it { should eq followed }
    end
  end

  describe "when followed id is not present" do
    before { relationship.followed_id = nil }
    it { is_expected.not_to be_valid }
  end

  describe "when follower id is not present" do
    before { relationship.follower_id = nil }
    it { is_expected.not_to be_valid }
  end
end
