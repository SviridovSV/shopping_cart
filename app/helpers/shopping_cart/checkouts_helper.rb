module ShoppingCart
  module CheckoutsHelper
    def address_has_error?(type, field)
      address = @order.get_address(type)
      address.errors.include?(field) if address
    end

    def address_error_message(type, field)
      address = @order.get_address(type)
      address.errors.messages[field][0] if address
    end

    def address_saved_value(type, field)
      user_address = current_user.get_address(type)
      address = @order.get_address(type)
      address.try(:[], field) || user_address.try(:[], field)
    end

    def use_billing_address?
      address = @order.get_address('billing')
      address.address_type == 'both' if address
    end

    def checked_delivery?(delivery_id)
      @order.delivery_id == delivery_id
    end

    def card_has_error?(field)
      @order.credit_card.errors.include?(field) if @order.credit_card
    end

    def card_error_message(field)
      @order.credit_card.errors.messages[field][0] if @order.credit_card
    end

    def card_saved_value(field)
      @order.credit_card[field] if @order.credit_card
    end

    def customer_name(type)
      @order.get_address(type).first_name + " " + @order.get_address(type).last_name
    end
  end
end
