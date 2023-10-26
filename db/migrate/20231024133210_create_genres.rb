class CreateGenres < ActiveRecord::Migration[7.0]
  def change
    create_table :genres do |t|
      t.integer :genre_id
      t.string :genre_name
      t.timestamps
    end
  end
end
