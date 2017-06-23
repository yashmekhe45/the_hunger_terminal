module TerminalsHelper
  def is_inactive_object?(object)
    !object.active
  end  
end

