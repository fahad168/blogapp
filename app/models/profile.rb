class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :profile_image, dependent: :destroy
  enum gender: { male: 1, female: 2, transgender: 3 }
end
