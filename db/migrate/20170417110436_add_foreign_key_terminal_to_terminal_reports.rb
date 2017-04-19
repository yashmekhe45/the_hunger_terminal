class AddForeignKeyTerminalToTerminalReports < ActiveRecord::Migration[5.0]
  def change
    add_reference :terminal_reports, :terminal,foreign_key: true ,index: true
  end
end
