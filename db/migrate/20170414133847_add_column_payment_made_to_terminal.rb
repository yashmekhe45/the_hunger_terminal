class AddColumnPaymentMadeToTerminal < ActiveRecord::Migration[5.0]
  def change
    add_column :terminals, :payment_made, :float, default: 0
  end
end
