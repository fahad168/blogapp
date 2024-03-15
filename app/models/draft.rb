class Draft < ApplicationRecord
  belongs_to :user
  has_one_attached :thumbnail
  has_many_attached :details_images
end
