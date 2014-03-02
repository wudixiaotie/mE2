# Load the Rails application.
require File.expand_path('../application', __FILE__)

# config mail
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address:              'smtp.gmail.com',
  port:                 587,
  domain:               'heroku.com',
  user_name:            'me2mailer@gmail.com',
  password:             '1987x1t9',
  authentication:       'plain',
  enable_starttls_auto: true
}

# Initialize the Rails application.
ME2::Application.initialize!