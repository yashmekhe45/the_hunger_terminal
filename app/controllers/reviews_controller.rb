class ReviewsController < ApplicationController

  def new
    @review = Review.new
  end

  def create
    review_params[:reviews].each do |review_param|
      @review = Review.new(review_param)
      @review[:company_id] = current_user.company_id
      @review[:reviewer_id] = current_user.id
      @review.save
    end
    (order = Order.find(params[:order][:id])).update(reviewed: true)
    respond_to do |format|
      format.js { @item_id = order.id }
    end
  end

  def skip_review
    Order.find(params[:order]).update(skipped_review: true)
  end

  def enter_review
    @order ||= Order.find(params[:order_id])
    @review = Review.new
  end

  def show_comments
    item = MenuItem.find(params[:item_id])
    @name = item.name
    @comments = item.reviews.where.not(comment: '').pluck(:comment)
  end

  private

  def review_params
    if params[:ratings]
      params[:reviews].each_with_index do |review, index|
        review[:rating] = params[:ratings]["#{index}"]
      end
    end
    params.permit(reviews: [:rating, :comment, :reviewable_type, :reviewable_id, :company_id])
  end

end
