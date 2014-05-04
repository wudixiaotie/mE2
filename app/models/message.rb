class Message < ActiveRecord::Base

  # scope

  default_scope -> { order("created_at DESC") }

  # Associations

  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :receiver, class_name: "User", foreign_key: "receiver_id"

  # Validates

  validates :sender_id, presence: true
  validates :receiver_id, presence: true
  validates :content, presence: true,
                      length: { maximum: 140 }

  # paginates_per for kaminari

  paginates_per 20
end