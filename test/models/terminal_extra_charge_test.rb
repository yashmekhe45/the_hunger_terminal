require "test_helper"

class TerminalextraChargeTest < ActiveSupport::TestCase

  test "employeewise extra charge should be divided" do
    @terminal = create(:terminal)
    @company = @terminal.company
    create_employees
    create_orders
    confirm_orders
    terminal_extra_charge = create(:terminal_extra_charge, company: @company, terminal: @terminal)
    #Get updated orders 
    order1 = Order.find(@order1.id)
    order2 = Order.find(@order2.id)

    employees_extra_charge = order1.extra_charges + order2.extra_charges
    extra_charge = terminal_extra_charge.daily_extra_charge

    assert_equal  employees_extra_charge, extra_charge
  end

  def create_employees
    @user1 = create(:user, company: @company)
    @user2 = create(:user, company: @company)
  end

  def create_orders
    @order1 = create(:order, company: @company, terminal: @terminal, user: @user1)
    @order2 = create(:order, company: @company, terminal: @terminal, user: @user2)
  end

  def confirm_orders
    @order1.update_attribute(:status, "confirmed")
    @order2.update_attribute(:status, "confirmed")
  end
end
