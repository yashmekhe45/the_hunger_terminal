require "test_helper"

describe OneClickOrder do
  let(:one_click_order) { OneClickOrder.new }

  it "must be valid" do
    value(one_click_order).must_be :valid?
  end
end
