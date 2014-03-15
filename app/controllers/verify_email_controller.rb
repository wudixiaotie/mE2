class VerifyEmailController < ApplicationController
  def new
  end

  def create
    session.delete(:user_email)

    user = User.find_by(email: params[:user_email])

    user.send_verify_email

    message = 'Email resend successfully! Please check your email.'

    redirect_to root_path, flash: { success: message }
  end

  def edit
    user = User.find(params[:id])

    user.send_verify_email

    message = 'Account created successfully! Please check your email.'

    redirect_to root_path, flash: { success: message }
  end

  def show
    user = User.find_by(verify_email_token: params[:id])
    
    user.verified = true

    user.save!(validate: false)

    message = "Sign up successfully! Now you can sign in!"

    redirect_to signin_path, flash: { success: message }
  end
end
