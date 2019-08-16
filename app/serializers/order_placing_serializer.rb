class OrderPlacingSerializer
  include FastJsonapi::ObjectSerializer
  attribute :bag_total do |drop_down_value, params|
  	params[:bag_total]
	end
  attribute :bag_tax do |drop_down_value, params|
    params[:bag_tax]
  end
  attribute :bag_discount do |drop_down_value, params|
    params[:bag_discount]
  end
  attribute :total_payable do |drop_down_value, params|
    params[:total_payable]
  end
end