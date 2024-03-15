class CreateDrafts < ActiveRecord::Migration[7.0]
  def change
    create_table :drafts do |t|
      t.string :title
      t.text :description
      t.text :details
      t.integer :user_id
      t.integer :type
      t.string :categories
      t.timestamps
    end
  end
end
