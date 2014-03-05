module SessionsHelper
	attr_writer :current_user

	def current_user
		sign_in_token = User.token_encrypt(cookies[:sign_in_token])
		@current_user ||= User.find_by(sign_in_token: sign_in_token)
	end

	def sign_in(user, keep_signed_in)
		sign_in_token = User.new_token

		if keep_signed_in
			cookies.permanent[:sign_in_token] = sign_in_token
		else
			cookies[:sign_in_token] = sign_in_token
		end

		user.update_attribute(:sign_in_token, User.token_encrypt(sign_in_token))
		self.current_user = user
	end

	def signed_in?
		!self.current_user.nil?
	end

	def sign_out
		self.current_user.update_attribute(:sign_in_token,
																				User.token_encrypt(User.new_token))
		self.current_user = nil
		cookies.delete(:sign_in_token)
	end
end
