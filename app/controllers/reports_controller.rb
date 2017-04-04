class ReportsController < ApplicationController

	def index
	@users = User.employee_report(current_user.company_id)
	# authorize! :index, :order_management 
	end

end
