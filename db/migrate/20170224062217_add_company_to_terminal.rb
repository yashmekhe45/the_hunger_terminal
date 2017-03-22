class AddCompanyToTerminal < ActiveRecord::Migration[5.0]
  def change
    add_reference :terminals, :company, foreign_key: true
  end
end
