class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]
  has_many :albums, dependent: :destroy
  has_one_attached :cover_image, dependent: :destroy
  has_one_attached :profile_image, dependent: :destroy
end
