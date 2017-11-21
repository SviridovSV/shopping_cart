FactoryGirl.define do
  factory :address, class: ShoppingCart::Address do
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    address_name "Street"
    city "City"
    zip "12345"
    country "Ukraine"
    phone "+3347645754"
  end
end