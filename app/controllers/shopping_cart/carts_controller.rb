
module ShoppingCart
  class CartsController < ApplicationController
    def show
      @order = current_order
      @order_items = @order.order_items
    end

    def update
      @coupon = Coupon.find_by(code: params[:coupon_code])
      @order = current_order
      if @coupon
        @order.update_attributes(coupon: @coupon.discount)
        redirect_to cart_path, notice: I18n.t('flash.coupon_activate')
      else
        redirect_to cart_path, alert: I18n.t('flash.wrong_coupon')
      end
    end
  end
end
