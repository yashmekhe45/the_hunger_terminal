class CreateTerminals < ActiveRecord::Migration[5.0]
  def change
    create_table :terminals do |t|
      t.string :name
      t.string :landline

      t.timestamps
    end
  end
end
