# frozen_string_literal: true

require "rails_helper"

RSpec.describe UsernamesController do
  describe "GET #index" do
    it "responds with HTTP 200, renders json" do
      user1 = create(:user)
      user2 = create(:user)
      sign_in(user1)

      get :index, format: :json

      expected_data = [
        ["#{user2.username} #{user2.name}",
         { handle: user2.username, name: user2.name }],
        ["#{user1.username} #{user1.name}",
         { handle: user1.username, name: user1.name }],
      ]

      expect(response).to be_ok
      expect(json).to eq expected_data
    end
  end
end
