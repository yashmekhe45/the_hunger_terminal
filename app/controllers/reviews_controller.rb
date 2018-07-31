class ReviewsController < ApplicationController

  def new
    if reviewable_type == 'terminal'
      @terminal = Terminal.find(params[:reviewable_id])
    elsif reviewable_type == 'menu_item'
      @menu_item = MenutItem.find(params[:reviewable_id])
    end
  end

  def create
    @review = Review.new(review_params)
  end

  def review_params
    params.require(:review)
          .permit(:rating, :comment, :criterion, :reviewable_type, :reviewable_id)
          .merge(company_id: current_user.company_id)
  end

end
