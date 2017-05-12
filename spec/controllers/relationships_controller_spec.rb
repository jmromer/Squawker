# frozen_string_literal: true

require "rails_helper"

describe RelationshipsController do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before { sign_in user }

  describe "creating a relationship with ajax" do
    it "should increment the Relationship count" do
      expect do
        xhr :post, :create, relationship: { followed_id: other_user.id }
      end.to change(Relationship, :count).by(1)
    end

    it "should respond with success" do
      xhr :post, :create, relationship: { followed_id: other_user.id }
      expect(response).to be_ok
    end
  end

  describe "destroying a relationship with ajax" do
    let(:relationship) { user.relationships.find_by(followed_id: other_user) }

    before { user.follow!(other_user) }

    it "should decrement the Relationship count" do
      expect do
        xhr :delete, :destroy, id: relationship.id
      end.to change(Relationship, :count).by(-1)
    end

    it "should respond with success" do
      xhr :delete, :destroy, id: relationship.id
      expect(response).to be_ok
    end
  end
end
