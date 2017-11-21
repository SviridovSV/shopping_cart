FactoryGirl.define do
  factory :coupon, class: ShoppingCart::Coupon do
    code "12345"
    discount 5
  end
end