class UserMailer < ActionMailer::Base
	default from: 'mE2'

  def verify_email(user, url)
  	@user = user
    @url = url

  	mail(to: user.email, subject: 'Verify your email account!')
  end

  def forget_password_email(user)
  	@user = user

  	param_hash = { id: user.id, time: Time.now.to_i }
  	url_code = url_params_encode(param_hash)
  	@url  = "#{request.original_url}/verify_email/#{url_code}"

  	mail(to: user.email, subject: 'Verify your email account!')
  end
end
