class AddReviewedToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :reviewed, :boolean, default: false
  end
end
