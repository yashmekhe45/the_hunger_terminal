class CustomActionsController < ApplicationController
  def selected_terminals
  	@company = Company.find(params[:company_id])
    @selected_terminals = @company.terminals.all.where(is_active:true)
  end
end 
