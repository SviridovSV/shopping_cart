module ShoppingCart
  module OrdersHelper
    def order_state_title(sort_type = :all)
      choose_sort = params[:sort_type] ? params[:sort_type] : sort_type
      Order::SORT_TITLES[choose_sort.to_sym]
    end
  end
end
