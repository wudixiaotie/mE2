class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
    if @user.save
  		redirect_to edit_verify_email_path(@user)
  	else
  		render 'new'
  	end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
  end

  def update
    if @user.update(user_params)
      sign_out
      redirect_to signin_path, flash: { success: 'Profile updated' }
    else
      render 'edit'
    end
  end

  private
  
    def user_params
      params.require(:user).permit(:name,
                                   :email,
                                   :password,
                                   :password_confirmation)
    end

    # Before filters

    def signed_in_user
      store_location
      redirect_to signin_path, flash: { warning: "Please sign in." } unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end
end