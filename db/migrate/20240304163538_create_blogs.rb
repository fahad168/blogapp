class CreateBlogs < ActiveRecord::Migration[7.0]
  def change
    create_table :blogs do |t|
      t.string :title
      t.text :description
      t.integer :user_id
      t.integer :type
      t.string :categories

      t.timestamps
    end
  end
end
