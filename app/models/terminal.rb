require "csv"
class Terminal < ApplicationRecord
  validates_with LandlineValidator
  validates :name, :landline ,presence: true
  validates :landline ,uniqueness: true
  validates :landline ,length:{ is:12 }

  has_many :menu_items,dependent: :destroy
  accepts_nested_attributes_for :menu_items, allow_destroy: true 

  def self.import(file,id)
    flag = true
    @terminal = Terminal.find(id)
    @menu_item_errors = MenuItem.new(name:"cxkvbivbad",price:2424,veg:true,terminal_id:id)
    CSV.foreach(file.path, headers: true) do |row|
      @menu_item= @terminal.menu_items.build(row.to_h)
      if @menu_item.valid?
        @menu_item.save
      else
        CSV.open("/home/project/Desktop/#{@terminal.name}-invalid_records.csv-#{DateTime.now}", "a+") do |csv|
          row << @menu_item.errors.messages.to_a
          csv << row
        end
        @menu_item_errors = @menu_item
      end 
    end 
    return @menu_item_errors
  end 
end