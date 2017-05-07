# frozen_string_literal: true

require "rails_helper"

describe "Static pages" do
  subject { page }

  describe "Home page" do
    before { visit root_path }
    it { should have_content("squawker") }
    it { should have_title(full_title("")) }
    it { is_expected.not_to have_title("| Home") }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:squawk, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:squawk, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
    end
  end

  describe "About page" do
    before { visit about_path }
    it { should have_content("About") }
    it { should have_title(full_title("About")) }
  end
end
