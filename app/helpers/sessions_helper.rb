module SessionsHelper
  attr_writer :current_user

  def current_user
    sign_in_token = User.token_encrypt(cookies[:sign_in_token])
    @current_user ||= User.find_by(sign_in_token: sign_in_token)
  end

  def current_user?(user)
    user == current_user
  end
    
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path, flash: { warning: "Please sign in." }
    end
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

  def redirect_back_or(default)
    redirect_to (session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.fullpath if request.get?
  end
end
