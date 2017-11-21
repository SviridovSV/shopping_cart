module ShoppingCart
  class OrderItemsController < ApplicationController
    after_action :save_user_to_order, only: :create
    after_action { current_order.save }
    load_resource through: :current_order, only: [:update, :destroy]

    def create
      @order = current_order
      @order_item = @order.order_items.new(order_item_params)
      session[:order_id] = @order.id if @order.save
    end

    def update
      if params[:operation] == 'minus' && @order_item
        update_order_item(1)
      elsif @order_item.book.in_stock?
        update_order_item(-1)
      else
        redirect_to cart_path, alert: I18n.t('flash.out_of_stock')
      end
    end

    def destroy
      if @order_item
        @order_item.destroy
        redirect_to cart_path, notice: I18n.t('flash.deleted')
      else
        redirect_to cart_path, alert: I18n.t('flash.was_not_found')
      end
    end

    private

    def order_item_params
      params.require(:order_item).permit(:quantity, :book_id)
    end

    def update_order_item(amount)
      @order_item.book.quantity += amount
      @order_item.quantity = params[:quantity]
      @order_item.save
      redirect_to cart_path, notice: I18n.t('flash.updated')
    end
  end
end
