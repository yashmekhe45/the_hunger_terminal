class MenuSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :terminal_id, :available, :veg, :price, :description, :active_days
  attribute :review do |record|
  	record.rating
	end
	attribute :terminal_rating do |drop_down_value, params|
    params[:terminal_rating]
  end 
end
