class CreateFollowers < ActiveRecord::Migration[7.0]
  def change
    create_table :followers do |t|
      t.integer :user_id
      t.integer :follower_id
      t.integer :status
      t.timestamps
    end
  end
end
