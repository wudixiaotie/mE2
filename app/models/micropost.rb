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
end