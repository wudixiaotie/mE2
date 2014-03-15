class PasswordResetController < ApplicationController
  def new
  end

  def create
    if params[:email].blank?
      flash.now[:danger] = 'Email invalid!'

      render 'new'
    else
      user = User.find_by(email: params[:email])

      if user
        user.send_password_reset_email

        redirect_to root_path, flash: { success: 'Email send successfully!' }
      else
        flash.now[:danger] = 'Email doesn\'t exist!'

        render 'new'
      end
    end
  end

  def edit
    @user = User.find_by(password_reset_token: params[:id])
    if @user.nil?
      redirect_to root_path
    end
  end

  def update
    @user = User.find_by(password_reset_token: params[:id])

    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, flash: { danger: 'Password reset has expired.' }
    elsif @user.update(user_params)
      redirect_to root_path, flash: { success: 'Reset password successfully!' }
    else
      render 'edit'
    end
  end

  private
    def user_params
      params.require(:user).permit(:password,
                                   :password_confirmation)
    end
end
