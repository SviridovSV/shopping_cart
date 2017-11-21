module ShoppingCart
  class CheckoutStepService
    def initialize(steps, params, order)
      @steps = steps
      @params = params
      @order = order
    end

    def set_current_step
      return if @params[:done]
      @steps.reverse.each do |stp|
        @step = stp unless has_completed?(stp)
      end
      @step
    end

    private

    def has_completed?(step)
      case step
      when :address
        @order.get_address("billing").try(:persisted?)
      when :delivery
        @order.delivery_id?
      when :payment
        @order.credit_card_id?
      when :confirm
        @order.in_queue?
      end
    end
  end
end
