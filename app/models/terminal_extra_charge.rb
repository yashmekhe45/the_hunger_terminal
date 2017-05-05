class TerminalExtraCharge < ApplicationRecord
  belongs_to :terminal
  belongs_to :company

  after_create :add_charges_in_employees_order_amount


  def add_charges_in_employees_order_amount
    terminal_id = self.terminal_id
    daily_extra_charge = self.daily_extra_charge
    company_id = self.company_id
    @todays_orders = Order.get_terminal_specific_orders(terminal_id, company_id)
    todays_user_count = @todays_orders.to_a.count
    extra_charge_per_employee = daily_extra_charge / todays_user_count
    @todays_orders.update_all("extra_charges =  #{extra_charge_per_employee}")
  end

end
