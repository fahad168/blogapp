class CreateAlbumContents < ActiveRecord::Migration[7.0]
  def change
    create_table :album_contents do |t|
      t.integer :movie_id
      t.string :imdb_id
      t.integer :album_id
      t.string :original_title
      t.string :release_date
      t.float :rating
      t.bigint :votes
      t.string :img_url
      t.text :description
      t.timestamps
    end
  end
end
