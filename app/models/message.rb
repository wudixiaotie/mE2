class Message < ActiveRecord::Base

  # scope

  default_scope -> { order("created_at DESC") }

  # Associations

  belongs_to :sender, class_name: "User",
                      foreign_key: "sender_name",
                      primary_key: "name"
  belongs_to :receiver, class_name: "User",
                        foreign_key: "receiver_name",
                        primary_key: "name"

  # Validates

  validates :sender_name, presence: true
  validates :receiver_name, presence: true
  validates :content, presence: true,
                      length: { maximum: 140 }

  # paginates_per for kaminari

  paginates_per 20
end