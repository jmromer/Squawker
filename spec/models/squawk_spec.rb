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

require 'rails_helper'

describe Squawk do

  let(:user) { FactoryGirl.create(:user) }
  before { @squawk = user.squawks.build(content: "Lorem ipsum") }

  subject { @squawk }
  it { is_expected.to respond_to(:content) }
  it { is_expected.to respond_to(:user_id) }
  it { is_expected.to respond_to(:user) }

  describe '#user' do
    subject { super().user }
    it { is_expected.to eq user }
  end
  it { is_expected.to be_valid }

  describe 'when user_id is not present' do
    before { @squawk.user_id = nil }
    it { is_expected.not_to be_valid }
  end

  describe "when user_id is not present" do
    before { @squawk.user_id = nil }
    it { is_expected.not_to be_valid }
  end

  describe "with blank content" do
    before { @squawk.content = " " }
    it { is_expected.not_to be_valid }
  end

  describe "with content that is too long" do
    before { @squawk.content = "a" * 161 }
    it { is_expected.not_to be_valid }
  end

end
