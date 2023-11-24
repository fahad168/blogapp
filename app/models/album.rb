class Album < ApplicationRecord
  belongs_to :user
  has_many :album_contents, dependent: :destroy
  has_one_attached :album_image
end
