require "test_helper"

describe TerminalReport do
  let(:terminal_report) { TerminalReport.new }

  it "must be valid" do
    value(terminal_report).must_be :valid?
  end
end
