module UsersHelper
  def is_inactive_user?(user)
    !user.is_active
  end
end
