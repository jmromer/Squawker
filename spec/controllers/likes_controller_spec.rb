# frozen_string_literal: true

require "rails_helper"

RSpec.describe LikesController, type: :controller do
  describe "GET #index" do
    context "given a valid user id" do
      it "returns http 200 and renders json" do
        like = create(:like)
        user = like.liker
        squawk = like.liked_squawk

        get :index, user_id: user.id

        expect(response).to be_ok
        expect(json).to be_instance_of Array
        expect(json.first).to eq(user_id: user.id, squawk_id: squawk.id)
      end
    end

    context "given a valid squawk id" do
      it "returns http 200 and renders json" do
        like = create(:like)
        user = like.liker
        squawk = like.liked_squawk

        get :index, squawk_id: squawk.id

        expect(response).to be_ok
        expect(json).to be_instance_of Array
        expect(json.first).to eq(user_id: user.id, squawk_id: squawk.id)
      end
    end

    context "given a invalid squawk id or user id" do
      it "returns http 422 and renders errors json" do
        like = create(:like)
        user = like.liker
        squawk = like.liked_squawk

        get :index, squawk_id: squawk.id

        expect(response).to be_ok
        expect(json).to be_instance_of Array
        expect(json.first).to eq(user_id: user.id, squawk_id: squawk.id)
      end
    end
  end

  describe "GET #create" do
    context "given a valid request" do
      it "responds with http 200 and persists the record" do
        user = create(:user)
        sign_in(user)
        squawk = create(:squawk)

        request = -> { xhr :post, :create, squawk_id: squawk.id }

        expect { request.call }.to change { Like.count }.by(+1)
        expect(response).to be_ok
      end
    end

    context "given an invalid request" do
      it "responds with http 422 and renders errors as json" do
        user = create(:user)
        sign_in(user)

        request = -> { xhr :post, :create, squawk_id: 9999 }

        expect { request.call }.to_not(change { Like.count })
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json).to have_key(:errors)
      end
    end
  end

  describe "GET #destroy" do
    it "returns http success" do
      like = create(:like)
      user = like.liker
      squawk = like.liked_squawk
      sign_in(user)

      request = -> { xhr :delete, :destroy, id: like.id, squawk_id: squawk.id }

      expect { request.call }.to change { Like.count }.by(-1)
      expect(response).to be_ok
    end

    context "given invalid parameters" do
      it "returns http 422 and error explanation" do
        like = create(:like)
        user = like.liker
        sign_in(user)

        request = -> { xhr :delete, :destroy, id: 999, squawk_id: 999 }

        expect { request.call }.to_not(change { Like.count })
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
