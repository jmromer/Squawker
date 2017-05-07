# frozen_string_literal: true

require "rails_helper"

RSpec.describe ActivityFeedController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      user = create(:user)
      sign_in(user)

      get :index

      expect(response).to be_ok
    end
  end
end
