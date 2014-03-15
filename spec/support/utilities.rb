include ApplicationHelper

def last_email
  ActionMailer::Base.deliveries.last
end

def sign_in(user, options = {})
  if options[:no_capybara]
    # Sign in when not using Capybara.
    sign_in_token = User.new_token
    cookies[:sign_in_token] = sign_in_token
    user.update_attribute(:sign_in_token,
                          User.token_encrypt(sign_in_token))
  else
    visit signin_path
    fill_in 'Email',    with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
  end
end