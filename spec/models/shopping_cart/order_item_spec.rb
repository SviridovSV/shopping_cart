require 'rails_helper'

module ShoppingCart
  RSpec.describe ShoppingCart::OrderItem, type: :model do
    before(:each) do
      @order = ShoppingCart::Order.create
      @book = Book.create(quantity: 1, price: 4, title: "dads")
      @order_item = ShoppingCart::OrderItem.create(quantity: 1, book_id: @book.id, order_id: @order.id)
    end

    describe "Validations" do
      [:quantity, :book_id].each do |field|
        it { expect(@order_item).to validate_presence_of(field) }
      end
      it { expect(@order_item).to validate_numericality_of(:quantity).is_greater_than(0) }

      it "Will not create if book count is not enough" do
        @order_item = ShoppingCart::OrderItem.new(quantity: 4, book_id: @book.id, order_id: @order.id)
        expect(@order_item.save).to eq(false)
      end

      it "Will not create if item alredy exist" do
        item = ShoppingCart::OrderItem.create(quantity: 1, book_id: @book.id, order_id: @order.id)
        expect(item.save).to eq(false)
      end
    end

    describe "Associations" do
      it { should belong_to(:order) }
      it { should belong_to(:book) }
    end

    describe "Callbacks" do
      before(:each) do
        @order = ShoppingCart::Order.create
        @book = Book.create(quantity: 3, price: 2, title: "aaaa")
        @order_item = ShoppingCart::OrderItem.new(quantity: 2, book_id: @book.id, order_id: @order.id)
      end

      it "decrease book quantity after create" do
        expect { @order_item.save }.to change { @order_item.book.quantity }.by(-2)
      end

      it "increase book quantity after destroy" do
        expect { @order_item.destroy }.to change { @order_item.book.quantity }.by(2)
      end
    end

    describe "#total_price" do
      it "must retrun book price * order item quantity" do
        expect(@order_item.total_price).to eq(4)
      end
    end
  end
end
