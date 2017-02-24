class CustomActionsController < ApplicationController
  def selected_terminals
    @selected_terminals = Terminal.all.where(is_active:true)
  end
end
