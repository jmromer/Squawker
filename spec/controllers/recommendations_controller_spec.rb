# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecommendationsController, type: :controller do
  render_views

  describe "GET #index" do
    context "Given a :squawk_id param" do
      it "responds with 200 and renders squawks" do
        allow(Warbler).to receive(:recommendations).and_return([2, 3])
        sign_in(create(:user))
        squawk1 = create(:squawk, id: 1)
        create(:squawk, id: 2)
        create(:squawk, id: 3)

        get :index, squawk_id: squawk1.id

        expect(response).to be_ok
        expect(response).to render_template("activity_feed/index")
        expect(response.body).to_not be_blank
        expect(response.body).to match(/id='2'/)
        expect(response.body).to match(/id='3'/)
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
