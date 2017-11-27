class CreateShoppingCartOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :shopping_cart_orders do |t|
      t.decimal :total_price, precision: 10, scale: 2
      t.integer :delivery_id, index: true
      t.integer :user_id, index: true
      t.integer :coupon, default: 0
      t.integer :credit_card_id, index: true
      t.string  :state

      t.timestamps
    end
  end
end
