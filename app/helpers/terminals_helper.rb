module TerminalsHelper
  def is_inactive_terminal?(terminal)
    print "terminal.active = ", terminal.is_active
    !terminal.is_active
  end  
end
