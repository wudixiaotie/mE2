class Micropost < ActiveRecord::Base

  # scope

  default_scope -> { order("created_at DESC") }

  # Associations

  belongs_to :user

  # Validates

  validates :user_id, presence: true
  validates :content, presence: true,
                      length: { maximum: 140 }

  # paginates_per for kaminari

  paginates_per 5

  # micropost from users followed by

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end
end