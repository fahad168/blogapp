class Blog < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  enum type: { blog: 1, article: 2 }
  belongs_to :user
  has_one_attached :thumbnail
  has_many_attached :details_images
end
