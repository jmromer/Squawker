# frozen_string_literal: true

class ActivityFeedController < ApplicationController
  layout false

  def index
    render :index, locals: { feed_items: current_user_feed }
  end

  private

  def current_user_feed
    current_user
      .feed
      .paginate(page: params[:page])
  end
end
