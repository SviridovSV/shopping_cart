require 'rails_helper'

module ShoppingCart
  RSpec.describe ShoppingCart::OrderItemsController, type: :controller do
    routes { ShoppingCart::Engine.routes }

    let(:order_item) { create(:order_item) }

    describe "POST #create" do
      before do
        allow(controller).to receive(:current_order).and_return(order)
        allow(controller).to receive(:save_user_to_order)
      end

      let(:order) { build(:order) }
      let(:book) { create(:book) }

      it "saves order item" do
        expect{
          post :create, params: { order_item: { quantity: 5, book_id: book.id } }, xhr: true
        }.to change(ShoppingCart::OrderItem, :count).by(1)
      end

      it "set session current order id" do
        post :create, params: { order_item: { quantity: 5, book_id: book.id } }, xhr: true
        expect(session[:order_id]).to eq(order.id)
      end
    end

    describe 'PATCH #update' do
      before do
        allow(controller).to receive(:current_order).and_return(order_item.order)
     end

      it "locates the requested @order_item" do
        patch :update, params: { id: order_item.id }
        expect(assigns(:order_item)).to eq(order_item)
      end

      context "when decrease order quantity" do
        before do
          patch :update, params: { id: order_item.id, operation: :minus,
                                          quantity: order_item.quantity - 1 }
        end

        it "order item quantity should decrease" do
          expect{ order_item.reload }.to change(order_item, :quantity).by(-1)
        end

        it "book quantity should increase" do
          expect{ order_item.book.reload }.to change(order_item.book, :quantity).by(1)
        end

        it "redirects to the cart with notice" do
          expect(response).to redirect_to cart_path
          expect(flash[:notice]).to be_present
        end
      end

      context "when increase order quantity" do
        before { patch :update, params: { id: order_item.id,
                                          quantity: order_item.quantity + 1 } }

        context "when book quantity is enough" do
          it "order item quantity should increase" do
            expect{ order_item.reload }.to change(order_item, :quantity).by(1)
          end

          it "book quantity should decrease" do
            expect{ order_item.book.reload }.to change(order_item.book, :quantity).by(-1)
          end

          it "redirects to the cart with notice" do
            expect(response).to redirect_to cart_path
            expect(flash[:notice]).to be_present
          end
        end

        context "when book quantity is not enough" do
          let(:order_item) { create(:order_item, quantity: 10) }

          it "redirects to the cart with alert" do
            expect(response).to redirect_to cart_path
            expect(flash[:alert]).to be_present
          end
        end
      end
    end

    describe "POST #create" do
      before { allow(controller).to receive(:current_order).and_return(order_item.order) }

      it "saves order item" do
        expect{ delete :destroy, params: { id: order_item.id } }.to change(ShoppingCart::OrderItem, :count).by(-1)
      end

      it "redirects to the cart with notice" do
        delete :destroy, params: { id: order_item.id }
        expect(response).to redirect_to cart_path
        expect(flash[:notice]).to be_present
      end
    end
  end
end
