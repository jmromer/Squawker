# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecommendationsController, type: :controller do
  describe "GET #index" do
    context "Given a :squawk_id param" do
      it "responds with 200 and renders squawks" do
        squawk0 = create(:squawk, content: "Wow, the internet, amiright??")

        get :index, squawk_id: squawk0.id

        expect(response).to be_ok
        expect(response).to render_template("activity_feed/index")
      end
    end

    context "Given no params" do
      it "responds with 422" do
        get :index
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
