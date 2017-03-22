class RemoveCompaniesFromCompanies < ActiveRecord::Migration[5.0]
  def change
    remove_column :companies, :companies, :float
  end
end
