require 'spec_helper'

describe "Squawk pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "squawk creation" do
    before { visit root_path }

    describe "with invalid information" do
      it "should not create a squawk" do
        expect { click_button "squawk it!" }.not_to change(Squawk, :count)
      end

      describe "error messages" do
        before { click_button "squawk it!" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'squawk_content', with: "Lorem ipsum" }
      it "should create a squawk" do
        expect { click_button "squawk it!" }.to change(Squawk, :count).by(1)
      end
    end
  end

  describe "squawk destruction" do
    before { FactoryGirl.create(:squawk, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a squawk" do
        expect do
          find('.delete-item').click
        end.to change(Squawk, :count).by(-1)
      end
    end
  end

end