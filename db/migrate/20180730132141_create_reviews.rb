class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.text :comment
      t.float :rating
      t.integer :company_id
      t.references :reviewer, class_name: :user
      t.references :reviewable, polymorphic: true

      t.timestamps
    end
  end
end
