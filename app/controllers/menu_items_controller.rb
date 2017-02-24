class MenuItemsController < ApplicationController
  def menu_index
    @menus = MenuItem.all
  end
end
