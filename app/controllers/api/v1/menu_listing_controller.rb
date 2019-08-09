class Api::V1::MenuListingController < ApiController

	before_action :load_company, only: [ :load_menu ]
  before_action :load_terminal, only: [ :load_menu ]

	def load_menu
		@menu_items = MenuItem.where(terminal: @terminal)
			.select(:id, :name, :terminal_id, :available, :veg, :price, :description, :active_days, 'avg(reviews.rating) as rating')
			.left_outer_joins(:reviews)
			.group(:id)
			.order('rating desc nulls last')
		@terminal_rating = Terminal.where(id: params[:terminal_id], active: true, company: @current_company)
			.select('avg(reviews.rating) as terminal_rating')
			.left_outer_joins(:reviews)
		render json: MenuSerializer.new(@menu_items, { params: {terminal_rating: @terminal_rating[0]["terminal_rating"]}}), status: 200
	end

	private

  def load_company
    @current_company = @current_user.company
  end

  def load_terminal
    @terminal = @current_company.terminals.find params[:terminal_id]
  end

end
