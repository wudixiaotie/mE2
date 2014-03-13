class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update ]
  before_action :correct_user, only: [:edit, :update]
  before_action :signed_up_user, only: [:new, :create]
  before_action :admin_user, only: [:destroy]

  def index
    @users = User.page(params[:page])
  end

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

  def destroy
    @user.destroy
    redirect_to users_path, flash: { success: 'User destroyed.' }
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
      unless signed_in?
        store_location
        redirect_to signin_path, flash: { warning: "Please sign in." }
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end

    def signed_up_user
      redirect_to root_path if signed_in?
    end

    def admin_user
      @user = User.find(params[:id])
      unless current_user.admin? && !current_user?(@user)
        redirect_to root_path
      end
    end
end