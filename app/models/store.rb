class Store < ApplicationRecord
  belongs_to :user
  has_one_attached :store_icon, dependent: :destroy
  enum status: { "In review": 1, "Approved": 2, "Rejected": 3 }
end
