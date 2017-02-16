class AddPolymorphicReferenceLocationToAddress < ActiveRecord::Migration[5.0]
  def change
    add_reference :addresses, :location, polymorphic: true, index: true
  end
end
