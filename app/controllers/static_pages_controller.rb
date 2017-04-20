# frozen_string_literal: true

class StaticPagesController < ApplicationController
  before_action :set_friendly_return_page, only: :home

  def home
    return unless signed_in?
    @page = params[:page]
    @squawk = current_user.squawks.build
    @feed_items = current_user.feed.paginate(page: @page)
  end

  def about; end

  def contact; end
end
