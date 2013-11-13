class StaticPagesController < ApplicationController
  before_action :set_friendly_return_page,  only: :home

  def home
    if signed_in?
      @squawk = current_user.squawks.build
      @feed_items = current_user.feed.paginate(
                      page: params[:page],
                      per_page: 20,
                      total_entries: 150
                    )
    end
  end

  # def help
  # end

  def about
  end

  def contact
  end
end