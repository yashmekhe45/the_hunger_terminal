class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.string :house_no
      t.integer :pincode
      t.string :locality
      t.string :city
      t.string :state

      t.timestamps
    end
  end
end
