class HomeController < ApplicationController

  skip_before_action :authenticate_user!, :only => [:index]
  before_action :load_company

  def index
  end

  private
  def load_company
    @company = current_user.company
  end
end
