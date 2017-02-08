class AddCompanyReferenceToAddress < ActiveRecord::Migration[5.0]
  def change
     add_reference :addresses, :company,foreign_key:true, index:true
  end
end
