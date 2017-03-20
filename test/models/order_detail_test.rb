require "test_helper"

describe OrderDetail do
  let(:order_detail) { OrderDetail.new }

  it "must be valid" do
    value(order_detail).must_be :valid?
  end
end
