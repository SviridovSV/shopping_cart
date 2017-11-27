FactoryGirl.define do
  factory :book do
    title FFaker::Book.title
    price 15
    quantity 10
    description FFaker::HealthcareIpsum.paragraph
  end
end