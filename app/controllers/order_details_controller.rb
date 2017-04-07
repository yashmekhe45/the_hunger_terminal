class OrderDetailsController < ApplicationController
	def destroy
		OrderDetail.find(params[:id]).destroy
	end
end
