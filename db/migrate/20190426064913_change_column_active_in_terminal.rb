class ChangeColumnActiveInTerminal < ActiveRecord::Migration[5.0]
  def up
    change_column :terminals, :active, :boolean, default: false
  end

  def down
    change_column :terminals, :active, :boolean, default: true
  end
end
