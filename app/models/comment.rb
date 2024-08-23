class Comment < ApplicationRecord
  belongs_to :blog
  belongs_to :user
  has_many :reactions, dependent: :destroy
  belongs_to :parent_comment, class_name: 'Comment', optional: true
  has_many :child_comments, class_name: 'Comment', foreign_key: :parent_comment_id
end
