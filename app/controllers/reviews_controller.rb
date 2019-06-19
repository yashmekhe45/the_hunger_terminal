class ReviewsController < ApplicationController

before_action :find_menu_item_with_reviews, only:[:show_comments, :destroy]

  def create
    review_params[:reviews].each do |review_param|
      @review = Review.new(review_param)
      @review[:company_id] = current_user.company_id
      @review[:reviewer_id] = current_user.id
      @review.save
    end
    from_date = 7.days.ago.strftime('%Y-%m-%d')
    to_date = Date.today.strftime('%Y-%m-%d')
    @orders = current_user.orders.includes(:order_details).includes(:terminal).where(status: "confirmed", date: Date.parse(from_date)..Date.parse(to_date)).order(date: :desc)
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
