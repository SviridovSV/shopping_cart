class User < ApplicationRecord
  has_many :addresses, dependent: :destroy, class_name: 'ShoppingCart::Address'
  has_many :orders, class_name: 'ShoppingCart::Order'
end