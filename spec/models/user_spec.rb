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
  it { should respond_to :name }
  it { should respond_to :username }
  it { should respond_to :email }
  it { should respond_to :password_digest }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }
  it { should respond_to :remember_token }
  it { should respond_to :authenticate }
  it { should respond_to :admin }
  it { should respond_to :squawks }
  it { should respond_to :feed }
  it { should respond_to :relationships }
  it { should respond_to :followed_users }
  it { should respond_to :reverse_relationships }
  it { should respond_to :followers }
  it { should respond_to :follow! }
  it { should respond_to :unfollow! }
  it { should respond_to :likes }

  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username).case_insensitive }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).is_at_most(50) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:password_confirmation) }
  it { should validate_uniqueness_of(:remember_token).case_insensitive }
  it { should validate_length_of(:password).is_at_least(8) }
  it { should validate_confirmation_of(:password) }

  it { should have_many(:likes) }
  it { should have_many(:squawks) }

  it "validates email format" do
    invalid_addresses = %w[user@foo,com
                           user_at_foo.org
                           foo@bar_baz.com
                           example.user@foo.
                           foo@bar+baz.com]

    valid_addresses = %w[user@foo.COM
                         A_US-ER@f.b.org
                         frst.lst@foo.jp
                         a+b@baz.cn]

    should_not allow_values(*invalid_addresses).for(:email)
    should allow_values(*valid_addresses).for(:email)
  end

  describe "#authenticate" do
    context "with valid password" do
      it "returns the requested user" do
        user = create(:user)
        found_user = User.find_by(email: user.email)

        user = found_user.authenticate(user.password)

        expect(user).to eq found_user
      end
    end

    context "with invalid password" do
      it "returns false" do
        user = create(:user)
        found_user = User.find_by(email: user.email)

        user = found_user.authenticate(user.password + "salt")

        expect(user).to eq false
      end
    end
  end

  context "squawk associations" do
    it "returns associated squawks in descending order of creation" do
      user = create(:user)
      older = create(:squawk, user: user, created_at: 1.year.ago)
      old = create(:squawk, user: user, created_at: 1.day.ago)
      new = create(:squawk, user: user, created_at: 1.hour.ago)

      expect(user.squawks.to_a).to eq [new, old, older]
    end

    it "should destroy associated squawks" do
      user = create(:user)
      3.times { create(:squawk, user: user) }
      in_memory_squawks = user.squawks.to_a

      user.destroy
      persisted_squawks = Squawk.where(id: in_memory_squawks.map(&:id))

      expect(in_memory_squawks.count).to eq 3
      expect(persisted_squawks).to be_empty
    end
  end

  describe "#follow!" do
    it "creates a follower association on the receiver" do
      followed = create(:user)
      follower = create(:user)
      non_follower = create(:user)

      follower.follow!(followed)

      users = followed.followers
      expect(users).to include(follower)
      expect(users).to_not include(non_follower)
      expect(follower).to be_following(followed)
      expect(non_follower).to_not be_following(followed)
    end

    context "given a follower relationship already exists" do
      it "does not allow persisting a new record" do
        followed = create(:user)
        follower = create(:user)
        follower.follow!(followed)

        duplicate_following = -> { follower.follow!(followed) }

        expect { duplicate_following.call }
          .to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe "#unfollow!" do
    it "destroys the follower association, returning the relationship record" do
      followed = create(:user)
      former_follower = create(:user)
      former_follower.follow!(followed)

      result = former_follower.unfollow!(followed)

      expect(result.follower).to eq former_follower
      expect(followed.followers).to_not include(former_follower)
      expect(former_follower).to_not be_following(followed)
    end

    context "given no follower relationship already exists" do
      it "does not allow persisting a new record" do
        followed = create(:user)
        follower = create(:user)

        result = follower.unfollow!(followed)

        expect(result).to be_nil
      end
    end
  end
end
