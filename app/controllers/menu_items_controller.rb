class MenuItemsController < ApplicationController
  def menu_index
  	@company = Company.find(params[:company_id])
  	@terminals = @company.terminals.where(:is_active => true).ids
  	@menus = MenuItem.where(:terminal_id => @terminals)
  end	
end
