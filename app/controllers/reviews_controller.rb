class ReviewsController < ApplicationController

  def create
    @review = Review.new(review_params)
  end

  def review_params
    params.require(:review)
          .permit(:rating, :comment, :criterion, :reviewable_type, :reviewable_id)
          .merge(company_id: current_user.company_id)
  end

end
