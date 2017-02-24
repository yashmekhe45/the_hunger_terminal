module TerminalsHelper
  def is_inactive_object?(object)
    print "object.active = ",object.is_active
    !object.is_active
  end  
end