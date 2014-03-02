class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
    if @user.save
      flash[:success] = 'Account created successfully!'

      @message = 'A email has been sent to your account, 
        which is to verify the onwership of the account, 
        please follow the instruction in the mail. Thank you!'
      
      # send email
      param_hash = { id: @user.id }
      url_code = url_params_encode(param_hash)
      url  = "#{request.original_url}/verify_email/#{url_code}"
      UserMailer.verify_email(@user, url).deliver

  		render '/shared/_message'
  	else
  		render 'new'
  	end
  end

  def verify_email
    param_hash = url_params_decode(params[:url_code])

    user = User.find(param_hash[:id])
    user.is_valid = true

    flash[:success] = 'Sign up successfully!'
    @message = "Now you can <a href='#{signin_path}'>sign in</a>!"

    render '/shared/_message'
  end

  def show
  	@user = User.find(params[:id])
  end

  def forget_password(url_code)
    param_hash = url_params_decode(url_code)

    if Time.now.to_i - param_hash[:time] > 1800
      flash[:error] = 'This link has timed out!'

      @message = 'Resend the email!'
    else
      User.find(param_hash[:id])
      flash[:success] = 'Sign up successfully!'

      @message = 'Now you can sign in!'
    end

    render '/shared/_message'
  end

  private
  
  def user_params
  	params.require(:user).permit(:name,
                                 :email,
                                 :password,
                                 :password_confirmation)
  end
end