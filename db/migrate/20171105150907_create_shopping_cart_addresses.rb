class CreateShoppingCartAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :shopping_cart_addresses do |t|
      t.string :first_name
      t.string :last_name
      t.string :city
      t.string :zip
      t.string :phone
      t.string :address_name
      t.string :address_type
      t.string :country
      t.integer :user_id, index: true
      t.integer :order_id, index: true

      t.timestamps
    end
  end
end
