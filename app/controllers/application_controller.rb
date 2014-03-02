class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  

  # encode hash to url
  def url_params_encode(param_hash)
  	str_hash = param_hash.to_s
  	code = Base64.encode64(str_hash)
  	url_code = URI.escape(code).gsub(/\+/,'%2B')
  end
  
  # decode url to hash
  def url_params_decode(url_code)
  	code = URI.unescape(url_code).gsub(/%2B/,'+')
  	str_hash = Base64.decode64(code)
  	eval(str_hash)
  end
end
