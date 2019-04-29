class InformNewTerminalAddedJob < ApplicationJob
  queue_as :default

  def perform(employee, terminal)
    OrderMailer.send_new_terminal_added_mail(employee, terminal).deliver_now
  end
end
