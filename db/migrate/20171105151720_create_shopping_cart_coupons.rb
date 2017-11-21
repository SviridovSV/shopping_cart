class CreateShoppingCartCoupons < ActiveRecord::Migration[5.1]
  def change
    create_table :shopping_cart_coupons do |t|
      t.string :code
      t.decimal :discount, precision: 10, scale: 2

      t.timestamps
    end
  end
end
