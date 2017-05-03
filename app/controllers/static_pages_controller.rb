# frozen_string_literal: true

class StaticPagesController < ApplicationController
  before_action :set_friendly_return_page, only: :home

  def home
    return unless signed_in?
    @squawk = current_user.squawks.build
    @feed_items = current_user.feed.paginate(page: params[:page])
  end

  def about; end

  def contact; end
end
