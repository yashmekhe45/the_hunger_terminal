class AddSkippedReviewToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :skipped_review, :boolean, default: false
  end
end
