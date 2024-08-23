class CreateFavrtEmojis < ActiveRecord::Migration[7.0]
  def change
    create_table :favrt_emojis do |t|
      t.integer :user_id
      t.string :emoji
      t.string :emoji_name
      t.timestamps
    end
  end
end
