class CreateEducations < ActiveRecord::Migration[7.0]
  def change
    create_table :educations do |t|
      t.string :school
      t.string :degree
      t.string :field_of_study
      t.string :skills, array: true, default: []
      t.date :start_date
      t.date :end_date
      t.string :grade
      t.integer :blogger_profile_id
      t.timestamps
    end
  end
end
