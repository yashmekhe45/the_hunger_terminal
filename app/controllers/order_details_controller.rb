class OrderDetailsController < ApplicationController

  def show
    order = Order.find(params[:order_id])
    user = current_user
    if (user.role == 'company_admin' and user.company_id == order.company_id)
      @details = order.order_details
    else
      flash[:error] = t(:not_authorised)
      redirect_to root_path
    end
  end

end
