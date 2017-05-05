require "test_helper"

describe TerminalExtraCharge do
  let(:terminal_extra_charge) { TerminalExtraCharge.new }

  it "must be valid" do
    value(terminal_extra_charge).must_be :valid?
  end
end
