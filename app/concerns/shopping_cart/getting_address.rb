module ShoppingCart
  module GettingAddress
    extend ActiveSupport::Concern

    def get_address(type)
      return addresses.first if addresses.first.try(:address_type_both?)
      addresses.select { |address| address.address_type == type }.first
    end
  end
end
