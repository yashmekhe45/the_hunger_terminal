class CreateSubscription < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|
      t.string :endpoint,   null: false
      t.string :auth_key,   null: false
      t.string :p256dh_key, null: false
    end
    add_reference :subscriptions, :user, foreign_key: true
  end
end
