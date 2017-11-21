module ShoppingCart
  class CheckoutMailer < ApplicationMailer
    def complete_email(user_id, order_id)
      @user = User.find(user_id)
      @order = Order.find(order_id)
      mail(to: @user.email, subject: "Your order R#{@order.id} is accepted")
    end
  end
end