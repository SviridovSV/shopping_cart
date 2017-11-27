module ShoppingCart
  class CheckoutPaymentService
    def initialize(order, params)
      @order = order
      @params = params
    end

    def create_or_update_card
      if @order.credit_card.try(:persisted?)
        @order.credit_card.update(credit_card_params)
      else
        @order.create_credit_card(credit_card_params)
      end
      @order.save
    end

    private

    def credit_card_params
      @params.require(:credit_card).permit(:card_number, :name_on_card, :mm_yy, :cvv)
    end
  end
end
