require "test_helper"

class TerminalTest < ActiveSupport::TestCase
  
  def test_should_not_save_terminal_without_name
    terminal = Terminal.new
    assert_not terminal.save
  end

  def test_should_not_save_terminal_without_landline
    
  end
end
