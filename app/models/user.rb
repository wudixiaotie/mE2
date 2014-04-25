class User < ActiveRecord::Base

  # Callback

  before_save :email_downcase
  before_create do
    self.sign_in_token = User.token_encrypt(User.new_token)
  end

  # Password

  has_secure_password

  # Associations

  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name: "Relationship",
                                   dependent: :destroy
  has_many :followers, through: :reverse_relationships

  # Validates

  VALID_NAME_REGEX = /\A\w+\z/i
  validates :name,  presence: true,
                    length: { maximum: 50 },
                    format: { with: VALID_NAME_REGEX },
                    uniqueness: { case_sensitive: false }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                    length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 6 }

  # paginates_per for kaminari

  paginates_per 10

  # Token

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def User.token_encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  # Email

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

  # feed
  
  def feed
    Micropost.from_users_followed_by(self.id)
  end

  # follow

  def follow!(other_user)
    self.relationships.create!(followed_id: other_user.id)
  end

  def following?(other_user)
    self.relationships.find_by(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    self.relationships.find_by(followed_id: other_user.id).destroy
  end

  private

    def email_downcase
     self.email.downcase!
    end
end