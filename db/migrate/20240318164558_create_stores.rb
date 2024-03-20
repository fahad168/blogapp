class CreateStores < ActiveRecord::Migration[7.0]
  def change
    create_table :stores do |t|
      t.string :title
      t.text :description
      t.string :product_categories, array: true, default: []
      t.integer :user_id
      t.integer :status

      t.timestamps
    end
  end
end
