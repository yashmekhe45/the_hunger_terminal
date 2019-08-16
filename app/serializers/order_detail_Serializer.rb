class OrderDetailSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :user_id, :company_id, :date, :total_cost, :terminal_id, :status, :discount, :extra_charges, :tax, :reviewed,
   :skipped_review, :total_payable, :menu_item_name, :quantity
end