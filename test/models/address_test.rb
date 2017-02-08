require "test_helper"

class AddressTest < ActiveSupport::TestCase
  def address
    @address ||= Address.new
  end

  def test_valid
    assert address.valid?
  end
end
