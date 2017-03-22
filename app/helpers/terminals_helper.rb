module TerminalsHelper
  def is_inactive_object?(object)
    print "object.active = ",object.active
    !object.active
  end  
end

