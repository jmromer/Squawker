def full_title(page_title)
  base_title = 'Squawker'
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

def sign_in(user, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara.
    remember_token = User.new_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
  else
    visit signin_path
    fill_in 'session_email',    with: user.email
    fill_in 'session_password', with: user.password
    click_button 'Sign In'
  end
end
