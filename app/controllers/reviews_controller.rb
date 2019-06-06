class ReviewsController < ApplicationController

before_action :find_menu_item_with_reviews, only:[:show_comments, :destroy]

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
    respond_to do |format|
      format.js
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
  end

  def destroy
    review = Review.find(params[:id])
    review.destroy 
    respond_to do |format|
      format.js
    end 
  end

  private

  def review_params
    if params[:ratings]
      params[:reviews].each_with_index do |review, index|
        index += 1 if params[:ratings]["#{index}"].nil? 
        review[:rating] = params[:ratings]["#{index}"]
      end
    end
    params.permit(reviews: [:rating, :comment, :reviewable_type, :reviewable_id, :company_id])
  end

  def find_menu_item_with_reviews
    @item = MenuItem.find(params[:item_id])
    @reviews = @item.reviews.order('created_at DESC')
  end
end
