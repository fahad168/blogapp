class Follower < ApplicationRecord
  belongs_to :user
  enum status: [:Pending, :Approved, :Rejected]
end
