class StaticPagesController < ApplicationController
  before_action :set_friendly_return_page,  only: :home

  def home
    if signed_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  # def help
  # end

  def about
  end

  def contact
  end
end