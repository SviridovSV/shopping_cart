module ShoppingCart
  class Order < ApplicationRecord
    include AASM
    include GettingAddress

    before_save { update_total_price }

    has_many :order_items, dependent: :destroy, class_name: ShoppingCart::OrderItem.name
    has_many :addresses, dependent: :destroy, class_name: ShoppingCart::Address.name

    belongs_to :user, optional: true
    belongs_to :delivery, optional: true, class_name: ShoppingCart::Delivery.name
    belongs_to :credit_card, optional: true, class_name: ShoppingCart::CreditCard.name

    SORT_TITLES = {all: 'All', in_progress: 'In Progress', in_queue: 'Waiting for processing',
                   in_delivery: 'In Delivery', delivered: 'Delivered', canceled: 'Canceled'}.freeze

    default_scope { order(created_at: :desc) }
    scope :in_progress, -> { where(state: :in_progress) }
    scope :in_queue, -> { where(state: :in_queue) }
    scope :in_delivery, -> { where(state: :in_delivery) }
    scope :delivered, -> { where(state: :delivered) }

    aasm column: 'state', whiny_transitions: false do
      state :in_progress, initial: true
      state :in_queue, :in_delivery, :delivered, :canceled

      event :confirm do
        after do
          ShoppingCart::CheckoutMailer.complete_email(user.id, self.id).deliver_now
        end
        transitions from: :in_progress, to: :in_queue
      end

      event :start_delivery do
        transitions from: :in_queue, to: :in_delivery
      end

      event :finish_delivery do
        transitions from: :in_delivery, to: :delivered
      end

      event :cancel do
        transitions from: [:in_queue, :in_delivery, :in_progress], to: :canceled
      end
    end

    def subtotal
      order_items.collect(&:total_price).sum
    end

    private

    def use_coupon
      return 0 if coupon >= subtotal
      coupon
    end

    def update_total_price
      self.total_price = subtotal - use_coupon + (delivery.nil? ? 0 : delivery.price)
    end
  end
end
