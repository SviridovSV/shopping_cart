module ShoppingCart
  class Delivery < ApplicationRecord
    has_many :orders, class_name: ShoppingCart::Order.name

    validates :price, :max_day, :min_day, numericality: { greater_than_or_equal_to: 0 }
  end
end