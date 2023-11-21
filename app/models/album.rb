class Album < ApplicationRecord
  belongs_to :user
  has_many :album_contents, dependent: :destroy
end
