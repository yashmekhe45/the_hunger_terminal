class AddSubsidyToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :subsidy, :float
  end
end
