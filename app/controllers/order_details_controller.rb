class OrderDetailsController < ApplicationController

  def show
    order = Order.find(params[:order_id])
    if current_user.is_company_admin? &&
       current_user.company_id == order.company_id
      @details = order.order_details
    else
      flash[:error] = t(:not_authorised)
      redirect_to root_path
    end
  end

end
