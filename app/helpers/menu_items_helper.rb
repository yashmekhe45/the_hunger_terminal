module MenuItemsHelper
  def is_available_menu_item?(object)
    !object.available
  end

  # def active_days_collection
  #   [['Monday', :Monday], ['Tuesday', :Tuesday], ['Wednesday', :Wednesday], ['Thursday', :Thursday], ['Friday',:Friday]]
  # end
end
