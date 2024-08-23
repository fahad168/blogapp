class CreateBloggerProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :blogger_profiles do |t|
      t.string :job_title
      t.string :location
      t.string :languages, array: true, default: []
      t.string :nickname
      t.text :summary
      t.integer :user_id
      t.timestamps
    end
  end
end
