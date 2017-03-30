module UsersHelper
  def is_inactive_user?(user)
    print "user.active = ", user.is_active
    !user.is_active
  end

  # def second_method(user)
  #   return user.name
  # end
end
