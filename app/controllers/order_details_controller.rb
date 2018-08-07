class OrderDetailsController < ApplicationController

  def show
    @details = OrderDetail.where(order_id: params[:order_id])
  end

end
