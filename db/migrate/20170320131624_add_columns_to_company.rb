class AddColumnsToCompany < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :start_ordering_at, :time
    add_column :companies, :review_ordering_at, :time
    add_column :companies, :end_ordering_at, :time
  end
end
