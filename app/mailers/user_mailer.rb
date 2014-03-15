class UserMailer < ActionMailer::Base
  default from: 'mE2<me2mailer@gmail.com>'

  def verify_email(user)
    @user = user

    mail(to: user.email, subject: 'Verify your email account!')
  end

  def password_reset_email(user)
    @user = user

    mail(to: user.email, subject: 'Reset your password!')
  end
end
