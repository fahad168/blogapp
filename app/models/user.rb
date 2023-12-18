class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2, :twitter2]
  after_create :make_settings
  has_many :albums, dependent: :destroy
  has_one_attached :cover_image, dependent: :destroy
  has_one_attached :profile_image, dependent: :destroy
  has_many :followings, class_name: "Following",foreign_key: :user_id, dependent: :destroy
  has_many :followers, class_name: "Follower",foreign_key: :user_id, dependent: :destroy
  has_one :setting, dependent: :destroy

  def make_settings
    self.build_setting.save
  end
end
