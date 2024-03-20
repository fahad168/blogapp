class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2, :twitter2]
  has_one_attached :cover_image, dependent: :destroy
  has_one_attached :profile_image, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_many :blogs
  has_many :drafts, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_many :stores, dependent: :destroy

  after_save :create_profile

  private

  def create_profile
    self.build_profile.save
  end
end
