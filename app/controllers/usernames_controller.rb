# frozen_string_literal: true

class UsernamesController < ApplicationController
  before_action :signed_in_user

  def index
    usernames = User.pluck(:username, :name)
    indexed_names = usernames.map do |handle, name|
      ["#{handle} #{name}", { handle: handle, name: name }]
    end

    respond_to do |format|
      format.json { render json: indexed_names }
    end
  end
end
