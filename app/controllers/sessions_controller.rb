class SessionsController < Devise::SessionsController

  # after_action :clear_flash, only: [:create ]

  # private

  # def clear_flash
  #   "==========="
  #   flash.clear
  # end



















  # after_action :remove_notice, only: [:create, :destroy]

  # private

  # def remove_notice
  #   flash[:notice] = ''
  # end












  def create
    super
    p "1111"
    flash.delete(:notice)
  end

  def destroy
    super
    p "22222"
    flash.delete(:notice)
  end

end