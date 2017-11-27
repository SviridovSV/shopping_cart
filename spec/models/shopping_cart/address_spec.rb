require 'rails_helper'

module ShoppingCart
  RSpec.describe Address, type: :model do
    describe "Validations" do
      [:first_name, :last_name, :address_name, :city].each do |field|
        it { should validate_length_of(field).is_at_most(50) }
      end
      it { should validate_length_of(:zip).is_at_most(10) }
      it { should validate_length_of(:phone).is_at_most(15) }

      context "When address belongs to order" do
        [:first_name, :last_name, :address_name, :city,
        :zip, :country, :phone].each do |field|
          it { should validate_presence_of(field) }
        end
      end

      context "When address belongs to user" do
        let(:user_address) {build(:address, user_id: 1)}

        [:first_name, :last_name, :address_name, :city,
        :zip, :country, :phone].each do |field|
          it { expect(user_address).not_to validate_presence_of(field) }
          it { expect(user_address).to allow_value(nil).for(field) }
        end
      end
    end
  end
end
