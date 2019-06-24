module ApplicationHelper
  def type_of_page
    request.path.eql?("/order/vendors")
  end
end
