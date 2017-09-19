require 'test_helper'

class ReportsHelperTest < ActionView::TestCase

  test "should work for 503" do
    last_month_total = 503
    assert_equal "₹ 510", round_of_total(last_month_total)
  end

  test "should work for 379" do
    last_month_total = 379
    assert_equal "₹ 380", round_of_total(last_month_total)
  end

  test "should work for 502.9" do
    last_month_total = 502.9
    assert_equal "₹ 500", round_of_total(last_month_total)
  end

  test "should work for 0" do
    last_month_total = 0
    assert_equal "₹ 0", round_of_total(last_month_total)
  end

  test "should work for 5.99" do
    last_month_total = 5.99
    assert_equal "₹ 10", round_of_total(last_month_total)
  end

end