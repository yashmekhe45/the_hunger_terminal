module UsersHelper
  def is_inactive_user?(user)
    return !user.is_active
  end
end
