class AddSubsidyToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :companies, :float
  end
end
