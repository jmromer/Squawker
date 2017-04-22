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

require "rails_helper"

describe User do
  before do
    @user = User.new(
      name: "Example User",
      username: "example_user",
      email: "user@example.com",
      password: "foobar",
      password_confirmation: "foobar"
    )
  end

  subject { @user }
  it { is_expected.to respond_to :name }
  it { is_expected.to respond_to :username }
  it { is_expected.to respond_to :email }
  it { is_expected.to respond_to :password_digest }
  it { is_expected.to respond_to :password }
  it { is_expected.to respond_to :password_confirmation }
  it { is_expected.to respond_to :remember_token }
  it { is_expected.to respond_to :authenticate }
  it { is_expected.to respond_to :admin }
  it { is_expected.to respond_to :squawks }
  it { is_expected.to respond_to :feed }
  it { is_expected.to respond_to :relationships }
  it { is_expected.to respond_to :followed_users }
  it { is_expected.to respond_to :reverse_relationships }
  it { is_expected.to respond_to :followers }
  it { is_expected.to respond_to :follow! }
  it { is_expected.to respond_to :unfollow! }
  it { is_expected.to be_valid }
  it { is_expected.not_to be_admin }

  it { is_expected.to validate_presence_of :username }
  it { is_expected.to validate_uniqueness_of(:username).case_insensitive }

  describe "with admin attribute set to 'true" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { is_expected.to be_admin }
  end

  describe "remember_token" do
    before { @user.save }

    describe "#remember_token" do
      subject { super().remember_token }
      it { is_expected.not_to be_blank }
    end
  end

  describe "when name is not present" do
    before { @user.name = " " }
    it { is_expected.not_to be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { is_expected.not_to be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { is_expected.not_to be_valid }
  end

  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                       password: " ", password_confirmation: " ")
    end
    it { is_expected.not_to be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { is_expected.to be_invalid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { is_expected.not_to be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { is_expected.to eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }
      it { is_expected.not_to eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to eq false }
    end
  end

  # Email Format
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  # Email Uniqueness
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.save
    end

    it { is_expected.not_to be_valid }
  end

  # Squawks
  describe "squawk associations" do
    before { @user.save }

    let!(:older_squawk) do
      FactoryGirl.create(:squawk, user: @user, created_at: 1.day.ago)
    end

    let!(:newer_squawk) do
      FactoryGirl.create(:squawk, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right squawks in the right order" do
      expect(@user.squawks.to_a).to eq [newer_squawk, older_squawk]
    end

    it "should destroy associated squawks" do
      squawks = @user.squawks.to_a
      @user.destroy
      expect(squawks).not_to be_empty
      squawks.each do |squawk|
        expect(Squawk.where(id: squawk.id)).to be_empty
      end
    end

    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:squawk, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }

      before do
        @user.follow!(followed_user)
        3.times { followed_user.squawks.create!(content: "Lorem ipsum") }
      end

      describe "#feed" do
        subject { super().feed }
        it { is_expected.to include(newer_squawk) }
      end

      describe "#feed" do
        subject { super().feed }
        it { is_expected.to include(older_squawk) }
      end

      describe "#feed" do
        subject { super().feed }
        it { is_expected.not_to include(unfollowed_post) }
      end

      describe "#feed" do
        subject { super().feed }
        it do
          followed_user.squawks.each do |squawk|
            is_expected.to include(squawk)
          end
        end
      end
    end
  end # squawk associations

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }

    before do
      @user.save
      @user.follow!(other_user)
    end

    it { is_expected.to be_following(other_user) }

    describe "#followed_users" do
      subject { super().followed_users }
      it { is_expected.to include(other_user) }
    end

    describe "followed user" do
      subject { other_user }

      describe "#followers" do
        subject { super().followers }
        it { is_expected.to include(@user) }
      end
    end

    describe "unfollowing" do
      before { @user.unfollow!(other_user) }
      it { is_expected.not_to be_following(other_user) }

      describe "#followed_users" do
        subject { super().followed_users }
        it { is_expected.not_to include(other_user) }
      end
    end
  end # following
end
