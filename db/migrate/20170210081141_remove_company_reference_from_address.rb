class RemoveCompanyReferenceFromAddress < ActiveRecord::Migration[5.0]
  def change
    remove_reference(:addresses, :company, index: true, foreign_key: true)
  end
end
