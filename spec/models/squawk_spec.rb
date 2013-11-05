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

require 'spec_helper'

describe Squawk do

  let(:user) { FactoryGirl.create(:user) }
  before { @squawk = user.squawks.build(content: "Lorem ipsum") }

  subject { @squawk }
  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user }
  it { should be_valid }

  describe 'when user_id is not present' do
    before { @squawk.user_id = nil }
    it { should_not be_valid }
  end

  describe "when user_id is not present" do
    before { @squawk.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank content" do
    before { @squawk.content = " " }
    it { should_not be_valid }
  end

  # describe "with content that is too long" do
  #   before { @squawk.content = "a" * 141 }
  #   it { should_not be_valid }
  # end

end
