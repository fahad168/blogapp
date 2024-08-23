class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2, :twitter2]
  after_create :create_profile_record, :create_blogger_profile_record

  after_create_commit :add_favrt_emoji
  has_many :blogs
  has_many :comments
  has_many :drafts, dependent: :destroy
  has_many :favrt_emojis, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_one :blogger_profile, dependent: :destroy
  has_many :likes, dependent: :destroy

  private
  def add_favrt_emoji
    ['joy', 'thumbsup', 'heart', 'white_check_mark', 'x'].each do |emoji_name|
      FavrtEmoji.create(emoji: Emoji.find_by_alias(emoji_name).raw, user_id: self.id, emoji_name: emoji_name)
    end
  end

  def create_profile_record
    self.build_profile.save
  end

  def create_blogger_profile_record
    self.build_blogger_profile.save
  end
end
