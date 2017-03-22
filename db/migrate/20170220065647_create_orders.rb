class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true
      t.references :company, foreign_key: true
      t.date :date
      t.integer :total_cost

      t.timestamps
    end
  end
end
