# frozen_string_literal: true

class SearchController < ApplicationController
  def show
    @page = params[:page]
    squawks = Squawk.search(params[:q]).paginate(page: @page).records
    render :show, locals: { squawks: squawks,
                            search_term: params[:q] }
  end
end
