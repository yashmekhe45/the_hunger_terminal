class AddExtraChargesColumnInOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :extra_charges, :integer, default: 0
  end
end
