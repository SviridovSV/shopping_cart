require 'rails_helper'
module ShoppingCart
  RSpec.describe ShoppingCart::CreditCard, type: :model do
    describe "Validations" do
      [:card_number, :name_on_card, :mm_yy, :cvv].each do |field|
        it { should validate_presence_of(field) }
      end
      it { should validate_length_of(:card_number).is_at_least(10) }
      it { should validate_length_of(:name_on_card).is_at_most(50) }
      it { should validate_length_of(:cvv).is_at_most(4) }
    end

    describe "Associations" do
      it { should have_many(:orders) }
    end
  end
end