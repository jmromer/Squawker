class StaticPagesController < ApplicationController
  before_action :set_friendly_return_page,  only: :home

  def home
    if signed_in?
      @squawk     = current_user.squawks.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def about
  end

  def contact
  end
end