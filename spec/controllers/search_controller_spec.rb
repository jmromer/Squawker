# frozen_string_literal: true

require "rails_helper"

describe SearchController, type: :controller do
  context "GET #show" do
    it "responds with status 200" do
      get :show

      expect(response).to be_ok
    end
  end
end
