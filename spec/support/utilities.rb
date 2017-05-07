# frozen_string_literal: true

def full_title(page_title)
  base_title = "Squawker"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

def sign_in(user, via_ui: false)
  raise ArgumentError if user.nil?
  return sign_in_via_ui(user) if via_ui

  remember_token = User.new_token
  cookies[:remember_token] = remember_token
  user.update_attribute(:remember_token, User.encrypt(remember_token))
  user
end

def sign_in_via_ui(user)
  visit signin_path
  fill_in "session_email", with: user.email
  fill_in "session_password", with: user.password
  click_button "Sign In"
  user
end

def json
  JSON.parse(response.body)
end
