# frozen_string_literal: true

require "rails_helper"

RSpec.describe FlagsController, type: :controller do
  describe "GET #create" do
    context "given a valid xhr request" do
      it "returns http success and persists the new record" do
        squawk = create(:squawk)
        user = create(:user)
        sign_in(user)

        request = -> { xhr :post, :create, squawk_id: squawk.id }

        expect { request.call }.to change { Flag.count }.by(1)
        expect(response).to be_ok
        expect(response.body).to be_blank
      end
    end

    context "given an http request" do
      it "it responds with 404" do
        squawk = create(:squawk)
        user = create(:user)
        sign_in(user)

        request = -> { delete :create, squawk_id: squawk.id }

        expect { request.call }.to_not(change { Flag.count })
        expect(response).to be_not_found
        expect(response.body).to be_blank
      end
    end

    context "given an invalid xhr request" do
      it "returns 422 and does not persist changes" do
        user = create(:user)
        sign_in(user)

        request = -> { xhr :post, :create, squawk_id: 999 }

        expect { request.call }.to_not(change { Flag.count })
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json).to have_key(:errors)
        expect(json[:errors]).to eq ["Flagged squawk can't be blank"]
      end
    end
  end

  describe "GET #destroy" do
    it "returns http success and destroys the record" do
      flag = create(:flag)
      user = flag.flagger
      squawk = flag.flagged_squawk
      sign_in(user)

      request = -> { xhr :delete, :destroy, squawk_id: squawk.id, id: flag.id }

      expect { request.call }.to change { Flag.count }.by(-1)
      expect(response).to be_ok
    end

    context "given invalid parameters" do
      it "returns http 422 and error explanation" do
        user = create(:user)
        sign_in(user)

        request = -> { xhr :delete, :destroy, squawk_id: 999, id: 999 }

        expect { request.call }.to_not(change { Flag.count })
        expect(response).to be_not_found
      end
    end

    context "given an http request" do
      it "returns http 422 and error explanation" do
        flag = create(:flag)
        user = flag.flagger
        squawk = flag.flagged_squawk
        sign_in(user)

        request = -> { delete :destroy, squawk_id: squawk.id, id: flag.id }

        expect { request.call }.to_not(change { Flag.count })
        expect(response).to be_not_found
      end
    end
  end
end
