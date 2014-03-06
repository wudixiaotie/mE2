class User < ActiveRecord::Base
	before_save :email_downcase
	before_create do		
		self.sign_in_token = User.token_encrypt(User.new_token)
	end
	
	validates :name, 	presence: true, length: { maximum: 50 }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email, presence: true,
										length: { maximum: 100 },
										format: { with: VALID_EMAIL_REGEX },
										uniqueness: { case_sensitive: false }

	has_secure_password
	validates :password, length: { minimum: 6 }

	def User.new_token
		SecureRandom.urlsafe_base64
	end

	def User.token_encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def send_verify_email
  	verify_email_token = User.token_encrypt(User.new_token)
  	self.verify_email_token = verify_email_token
  	self.save!(validate: false)
    UserMailer.verify_email(self).deliver
  end

  def send_password_reset_email
  	password_reset_token = User.token_encrypt(User.new_token)
  	self.password_reset_token = password_reset_token
  	self.password_reset_sent_at = Time.zone.now
  	self.save!(validate: false)
    UserMailer.password_reset_email(self).deliver
  end

	private

		def email_downcase
			self.email.downcase!
		end
end