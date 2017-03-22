class AddImageToTerminals < ActiveRecord::Migration[5.0]
  def change
    add_column :terminals, :image, :string
  end
end
