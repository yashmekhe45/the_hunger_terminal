class AddReviewedAndSkippedReviewToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :reviewed, :boolean
    add_column :orders, :skipped_review, :boolean
  end
end
