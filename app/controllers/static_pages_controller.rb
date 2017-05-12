# frozen_string_literal: true

class StaticPagesController < ApplicationController
  before_action :set_friendly_return_page, only: :home

  def home
    if signed_in?
      render :home, locals: { squawk: current_user.squawks.build }
    else
      render :splash
    end
  end

  def about; end

  def contact; end
end
