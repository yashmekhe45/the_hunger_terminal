class SetDefaultValueOfDailyExtraChargeToZero < ActiveRecord::Migration[5.0]
  def change
    change_column :terminal_extra_charges, :daily_extra_charge, :integer, default: 0
  end
end
