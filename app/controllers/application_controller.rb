# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  def redirect_to_twitter(username:)
    redirect_to "https://twitter.com/#{username.try(:downcase)}"
  end

  def set_friendly_return_page
    session[:return_to] = request.url if request.get?
  end
end
