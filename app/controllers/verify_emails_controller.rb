class VerifyEmailsController < ApplicationController
	@message = 'A email has been sent to your account, 
    which is to verify the onwership of the account, 
    please follow the instruction in the mail. Thank you!'

	def new
	end

  def create
    flash.now[:success] = 'Email resend successfully!'

    user = User.find_by(email: params[:user_email])

    user.send_verify_email

    render '/shared/_message'
  end

  def edit
    flash.now[:success] = 'Account created successfully!'
    
    user = User.find(params[:id])

    user.send_verify_email

    render '/shared/_message'
  end

  def show
    user = User.find_by(verify_email_token: params[:id])
    user.is_valid = true

    flash.now[:success] = 'Sign up successfully!'
    @message = "Now you can <a href='#{signin_path}'>sign in</a>!"

    render '/shared/_message'
  end
end
