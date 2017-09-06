module ReportsHelper

  def round_of_total(last_month_total)
    num = last_month_total % 10
    last_month_total = (num >= 3)?
                      ((last_month_total/10).floor+1) * 10
                       : (last_month_total/10).floor * 10
    p "₹ " + "#{last_month_total}"
  end

  
end
