class DropTableCompany < ActiveRecord::Migration[5.0]
  def change
    drop_table :companies
  end
end
