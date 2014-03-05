module SessionsHelper
	attr_writer :current_user

	def current_user
		remember_token = User.encrypt(cookies[:remember_token])
		@current_user ||= User.find_by(remember_token: remember_token)
	end

	def sign_in(user, keep_signed_in)
		remember_token = User.new_remember_token

		if keep_signed_in
			cookies.permanent[:remember_token] = remember_token
		else
			cookies[:remember_token] = remember_token
		end

		user.update_attribute(:remember_token, User.encrypt(remember_token))
		self.current_user = user
	end

	def signed_in?
		!self.current_user.nil?
	end

	def sign_out
		self.current_user.update_attribute(:remember_token,
																				User.encrypt(User.new_remember_token))
		self.current_user = nil
		cookies.delete(:remember_token)
	end
end
