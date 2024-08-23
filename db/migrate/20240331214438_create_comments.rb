class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.text :comment_details
      t.integer :user_id
      t.integer :blog_id
      t.timestamps
    end
  end
end
