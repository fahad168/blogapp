class CreateAlbums < ActiveRecord::Migration[7.0]
  def change
    create_table :albums do |t|
      t.string :title
      t.integer :total_movies, default: 0
      t.integer :total_views, default: 0
      t.integer :shared_count, default: 0
      t.boolean :private, default: false
      t.string :album_type
      t.string :album_genre
      t.integer :user_id
      t.string :shareable_link
      t.timestamps
    end
  end
end
