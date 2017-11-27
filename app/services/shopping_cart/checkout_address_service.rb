module ShoppingCart
  class CheckoutAddressService
    def initialize(order, params)
      @order = order
      @params = params
    end

    def create_or_update_address
      if @order.get_address('billing').try(:persisted?)
        update_addresses
      else
        create_addresses
      end
    end

    private

    def billing_address_params
      @params.require(:billing).permit(:first_name, :last_name, :address_name, :city, :zip, :country, :phone, :address_type)
    end

    def shipping_address_params
      @params.require(:shipping).permit(:first_name, :last_name, :address_name, :city, :zip, :country, :phone, :address_type)
    end

    def create_addresses
      @order.addresses.new(billing_address_params)
      @order.addresses.new(shipping_address_params) unless @params[:billing][:address_type] == 'both'
    end

    def update_addresses
      @order.get_address('billing').update(billing_address_params)
      return if @params[:billing][:address_type] == 'both'
      if @order.addresses.size < 2
        @order.addresses.new(shipping_address_params)
      else
        @order.get_address('shipping').update(shipping_address_params)
      end
    end
  end
end
