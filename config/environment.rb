# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Load environment varibles
env_yml = YAML.load_file("#{Rails.root}/config/environment_variables.yml")
env_yml[Rails.env].each {|k,v| ENV[k] = v }

# config mail
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address:              'smtp.gmail.com',
  port:                 587,
  domain:               'heroku.com',
  user_name:            ENV['GMAIL_USERNAME'],
  password:             ENV['GMAIL_PASSWORD'],
  authentication:       'plain',
  enable_starttls_auto: true
}

# Initialize the Rails application.
ME2::Application.initialize!