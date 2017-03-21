class AddEmailToTerminal < ActiveRecord::Migration[5.0]
  def change
    add_column :terminals, :email, :string
  end
end
