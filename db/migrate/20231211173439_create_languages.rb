class CreateLanguages < ActiveRecord::Migration[7.0]
  def change
    create_table :languages do |t|
      t.string :iso_name
      t.string :english_name
      t.string :name

      t.timestamps
    end
  end
end
