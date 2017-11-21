require 'rails_helper'

module ShoppingCart
  RSpec.describe ShoppingCart::Delivery, type: :model do
    describe "Validations" do
      [:price, :max_day, :min_day].each do |field|
        it { should validate_numericality_of(field).is_greater_than_or_equal_to(0) }
      end
    end

    describe "Associations" do
      it { should have_many(:orders) }
    end
  end
end