class Book < ApplicationRecord
  has_many :order_items, class_name: 'ShoppingCart::OrderItem'

  def in_stock?
    quantity > 0
  end

end