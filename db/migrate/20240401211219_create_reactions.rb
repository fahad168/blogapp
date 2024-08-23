class CreateReactions < ActiveRecord::Migration[7.0]
  def change
    create_table :reactions do |t|
      t.string :emoji
      t.string :emoji_name
      t.integer :user_id
      t.integer :comment_id

      t.timestamps
    end
  end
end
