class AddColumnIsNotifiedToEmployeeToTerminal < ActiveRecord::Migration[5.0]
  def change
    add_column :terminals, :is_notified_to_employee, :boolean, default: false
  end
end
