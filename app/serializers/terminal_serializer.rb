class TerminalSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :image, :active, :min_order_amount, :tax
  attribute :review do |record|
  	record.rating
	end
  attribute :end_ordering_at do |drop_down_value, params|
    params[:end_ordering_at]
  end
end
