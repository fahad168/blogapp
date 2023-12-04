class CreateSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :settings do |t|
      t.boolean :private_account, default: false
      t.boolean :private_albums, default: false
      t.boolean :adult_content, default: false
      t.integer :user_id
      t.timestamps
    end
  end
end
