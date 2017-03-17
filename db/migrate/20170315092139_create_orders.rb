class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.date :date
      t.float :total_cost
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
