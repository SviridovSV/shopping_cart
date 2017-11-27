module ShoppingCart
  class OrderItem < ApplicationRecord
    after_create :decrease_book_quantity
    after_destroy :increase_book_quantity

    belongs_to :order, optional: true, class_name: ShoppingCart::Order.name
    belongs_to :book, optional: true, autosave: true

    validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :book_id, presence: true
    validate :book_quantity, on: :create
    validate :order_item_uniq, on: :create
    validate :order_present

    default_scope { order(created_at: :desc) }

    def total_price
      book.price * quantity
    end

    private

    def decrease_book_quantity
      book.quantity -= quantity
      book.save
    end

    def increase_book_quantity
      book.quantity += quantity
      book.save
    end

    def order_present
      return if order
      errors.add(:order, 'is not a valid order.')
    end

    def book_quantity
      return unless book.quantity < quantity
      errors.add(:order_item, 'is out of stock.')
    end

    def order_item_uniq
      return unless order.order_items.find_by(book_id: book.id)
      errors.add(:order_item, 'is already in cart.')
    end
  end
end
