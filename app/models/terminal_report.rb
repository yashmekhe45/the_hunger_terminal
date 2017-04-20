class TerminalReport < ApplicationRecord
  
  belongs_to :terminal

  # def self.individual_terminal_last_month_report(t_id)
  #   return TerminalReport.where(terminal_id:t_id)
  # end
end
