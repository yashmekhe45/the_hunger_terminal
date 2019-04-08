module TerminalsHelper
  def is_inactive_object?(object)
    !object.active
  end

  def todays_order
    current_user.todays_order
  end
end

