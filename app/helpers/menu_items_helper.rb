module MenuItemsHelper
  def is_available_menu_item?(object)
    print "object.available = ",object.available
    !object.available
  end
end
