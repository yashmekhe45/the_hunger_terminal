require "test_helper"

class ReviewsControllerTest  < ActionController::TestCase

  before :each do
    @user = create(:user)
  end
  let(:order) { create(:order) }
  let(:ratings) {{"1" => "5"}}
  let(:review_attributes) { attributes_for(:review)}
  let(:menu_item) {build(:menu_item)}
  let(:review) {FactoryGirl.build(:review, reviewable: menu_item, reviewer: @user )}
  
  test "create new review" do
    sign_in_new_user
    post :create, params: {reviews: [review_attributes], ratings: ratings}, format: 'js'
    assert_response :success
  end

  test "show comments of a particular menu_item" do
    sign_in_new_user
    menu_item = create(:menu_item)
    get :show_comments, params: {type: menu_item.class, type_id: menu_item.id}, xhr: true
    assert_response :success
  end

  test "destroy comment of particular menu_item" do
    sign_in_new_user
    menu_item = create(:menu_item)
    review = create(:review)
    delete :destroy, params: {id: review.id, type_id: menu_item.id, type: menu_item.class}, format: 'js'
    assert_response :success
  end

  test "update skip review to true  when user skipped review" do
    sign_in_new_user
    patch :skip_review, params: {order: order.id}, format: 'js'
    assert_response :success
  end

  def sign_in_new_user
    @user.confirm
    sign_in @user
  end

end
