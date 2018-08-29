class ReviewsController < ApplicationController

  def new
    @review = Review.new
  end

  def create
    review_params[:reviews].each_with_index do |review_param, index|
      @review = Review.new(review_param)
      @review.save
      flash[:success] = 'Review added!!'
    end
  end

  private

  def review_params
    params[:reviews].each_with_index do |review, index|
      review[:rating] = params[:ratings]["#{index}"] if params[:ratings]
      review[:company_id] = current_user.company_id
    end
    params.permit(reviews: [:rating, :comment, :reviewable_type, :reviewable_id, :company_id])
  end

end
