# frozen_string_literal: true

class SearchController < ApplicationController
  def show
    squawks = Squawk.search(params[:q]).records
    render :show, locals: { squawks: squawks }
  end
end
