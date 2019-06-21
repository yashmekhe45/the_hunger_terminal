require "test_helper"

describe Review do
  let(:review) {FactoryGirl.build(:review)}

  it "must be valid" do
    assert review.valid?
  end
end
