FactoryGirl.define do
  factory :order_item, class: ShoppingCart::OrderItem do
    association :book
    association :order
    quantity 5
  end
end