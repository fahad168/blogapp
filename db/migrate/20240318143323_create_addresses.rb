class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :countries
      t.string :states
      t.string :cities
      t.string :street_address
      t.string :zipcode
      t.string :apartment_number
      t.integer :user_id

      t.timestamps
    end
  end
end
