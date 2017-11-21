FactoryGirl.define do
  factory :credit_card, class: ShoppingCart::CreditCard do
    card_number FFaker::Book.isbn
    name_on_card "Name"
    mm_yy "11/11"
    cvv "123"
  end
end