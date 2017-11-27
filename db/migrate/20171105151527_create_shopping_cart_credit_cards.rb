class CreateShoppingCartCreditCards < ActiveRecord::Migration[5.1]
  def change
    create_table :shopping_cart_credit_cards do |t|
      t.string :card_number
      t.string :name_on_card
      t.string :mm_yy
      t.string :cvv

      t.timestamps
    end
  end
end
