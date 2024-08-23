class BloggerProfile < ApplicationRecord
  belongs_to :user
  has_many :educations, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_one_attached :cover_image, dependent: :destroy
end
