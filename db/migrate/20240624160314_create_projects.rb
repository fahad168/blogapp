class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.integer :blogger_profile_id
      t.string :name
      t.text :description
      t.date :start_date
      t.date :end_date
      t.boolean :checked, default: false
      t.string :skills, array: true, default: []

      t.timestamps
    end
  end
end
