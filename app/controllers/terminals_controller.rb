class TerminalsController < ApplicationController
  def new
    @terminal = Terminal.new
    @terminal.menu_items.build
  end

  def index
    @terminal = Terminal.all
  end 

  def create
    @terminal = Terminal.new(terminal_param)
     if @terminal.save
      redirect_to terminals_path
    else
      render :new
    end
  end

  def edit
    @terminal = Terminal.find(params[:id])
  end

  def show
    @terminal = Terminal.find(params[:id])
    @menu_items = @terminal.menu_items.all
  end  

  def update
    @terminal = Terminal.find(params[:id])
    if @terminal.update_attributes(terminal_param)
      flash[:success] = "terminal updated"
      if @terminal.menu_items.empty?
        @terminal.destroy
        redirect_to terminals_path
      else
        redirect_to terminal_path
      end
    else
      render 'edit'
    end
  end

  def destroy
    @terminal = Terminal.find(params[:id])
    @terminal.destroy
    redirect_to terminals_path
  end

  def import
    @menu_item_errors,$FILE = Terminal.import(params[:file],params[:id]) 
    if @menu_item_errors.valid?
      redirect_to terminal_path notice: "You have successfully added menu items."
    else
      download 
    end
  end  

  private

  def terminal_param
    params.require(:terminal).permit(:name,:landline, menu_items_attributes: [:id, :name, :veg, :price, :_destroy])
  end

  def download
    send_file("#{Rails.root}/#{$FILE}")
  end
end
