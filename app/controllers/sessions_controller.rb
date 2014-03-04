class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.find_by(email: params[:email].downcase)
		keep_singed_in = !params[:keep_singed_in].nil?
		if user && user.authenticate(params[:password])
			sign_in user
			redirect_to user
		else
			flash.now[:danger] = 'Invalid email/password combination'
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_path
	end
end
