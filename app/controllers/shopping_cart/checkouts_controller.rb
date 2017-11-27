module ShoppingCart
  class CheckoutsController < ApplicationController
    include Wicked::Wizard
    include GettingAddress

    before_action :authenticate_user!
    before_action :check_empty_cart

    steps :address, :delivery, :payment, :confirm, :complete

    def show
      @order = current_order
      jump_to(CheckoutStepService.new(steps, params, @order).set_current_step, done: true)
      session.delete(:order_id) if step == :complete && params[:done]
      render_wizard
    end

    def update
      @order = current_order

      case step
      when :address
        CheckoutAddressService.new(@order, params).create_or_update_address
        render_addresses_forms
      when :delivery
        render_delivery_form
      when :payment
        CheckoutPaymentService.new(@order, params).create_or_update_card
        render_wizard @order.credit_card
      when :confirm
        @order.confirm
        render_wizard @order
      end
    end

    private

    def render_addresses_forms
      if @order.get_address('billing').errors.any? || @order.get_address('shipping').errors.any?
        render_wizard
      else
        render_wizard @order
      end
    end

    def render_delivery_form
      if params[:delivery]
        @order.delivery_id = params[:delivery]
        render_wizard @order
      else
        flash.now[:alert] = I18n.t('flash.delivery_alert')
        render_wizard
      end
    end

    def check_empty_cart
      redirect_to cart_path, alert: I18n.t('flash.empty_cart') unless current_order.order_items.any?
    end
  end
end
