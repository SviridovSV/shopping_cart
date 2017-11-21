module ShoppingCart
  module ApplicationHelper
    def items_in_cart
      current_order.order_items.size
    end

    def track_number(order)
      "R #{order.id}"
    end
  end
end
