require 'rails_helper'

module ShoppingCart
  RSpec.describe ShoppingCart::Order, type: :model do
    describe "Associations" do
      it { should belong_to(:user) }
      it { should belong_to(:delivery) }
      it { should belong_to(:credit_card) }
      it { should have_many(:order_items).dependent(:destroy) }
      it { should have_many(:addresses).dependent(:destroy) }
    end

    describe "States" do
      subject { ShoppingCart::Order.new }
      before { subject.save }

      it "Default state is In Progress" do
        expect(subject).to have_state(:in_progress)
      end

      it "After confirm should have state Waiting for processing" do
        subject.user = create(:user)
        subject.confirm
        expect(subject).to have_state(:in_queue)
      end

      it "After start delivery should have state In Delivery" do
        subject.user = create(:user)
        subject.confirm
        subject.start_delivery
        expect(subject).to have_state(:in_delivery)
      end

      it "After finish delivery should have state Delivered" do
        subject.state = :in_delivery
        subject.finish_delivery
        expect(subject).to have_state(:delivered)
      end

      it "Order can be canceled" do
        expect(subject).to transition_from(:in_delivery, :in_queuen, :in_progress)
                       .to(:canceled).on_event(:cancel)
      end
    end

    describe "#subtotal" do
      before do
        @item = ShoppingCart::OrderItem.new
        @item2 = ShoppingCart::OrderItem.new
        allow(@item).to receive(:total_price).and_return(12)
        allow(@item2).to receive(:total_price).and_return(10)
        @order = ShoppingCart::Order.new(order_items: [@item, @item2])
      end

      it "Return sum of items prices" do
        expect(@order.subtotal).to eq(22)
      end
    end

    describe "#get_address" do
      let(:shipping) { build(:address, address_type: "shipping")}
      let(:billing) { build(:address, address_type: "billing")}
      let(:both) { build(:address, address_type: "both")}

      context "when type is shipping" do
        it "Return shipping address" do
          order = ShoppingCart::Order.new(addresses: [shipping])
          expect(order.get_address("shipping")).to eq(shipping)
        end
      end

      context "when type is billing" do
        it "Return billing address" do
          order = ShoppingCart::Order.new(addresses: [billing])
          expect(order.get_address("billing")).to eq(billing)
        end
      end

      context "when type is both" do
        it "Return billing address" do
          order = ShoppingCart::Order.new(addresses: [both])
          expect(order.get_address(nil)).to eq(both)
        end
      end
    end

    describe "#use_coupon" do
      it "return 0 if there is no coupon" do
        expect(ShoppingCart::Order.new.send(:use_coupon)).to eq(0)
      end

      it "return coupon discount" do
        order = ShoppingCart::Order.new(coupon: 5)
        allow(order).to receive(:subtotal).and_return(10)
        expect(order.send(:use_coupon)).to eq(5)
      end
    end
  end
end
