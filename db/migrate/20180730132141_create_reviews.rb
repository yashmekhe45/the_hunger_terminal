class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.float :rating
      t.text :comment
      t.integer :company_id
      t.references :reviewable, polymorphic: true

      t.timestamps
    end
  end
end
