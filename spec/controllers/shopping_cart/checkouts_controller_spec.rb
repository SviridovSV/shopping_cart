require 'rails_helper'

module ShoppingCart
  RSpec.describe  ShoppingCart::CheckoutsController, type: :controller do
    routes { ShoppingCart::Engine.routes }

    before do
      allow(controller).to receive(:current_order).and_return(order)
      allow(controller).to receive(:check_empty_cart)
      allow(controller).to receive(:authenticate_user!)
    end

    let(:user) { create(:user) }
    let(:order) { create(:order, user_id: user.id) }

    describe 'GET #show' do
      before { allow(controller).to receive(:jump_to) }

      context 'when step is address' do
        before { get :show, params: { id: :address } }

        it 'assigns the current order to :order' do
          expect(assigns(:order)).to eq order
        end

        it 'assigns :address to step' do
          expect(assigns(:step)).to eq(:address)
        end

        it 'renders the :address template' do
          expect(response).to render_template :address
        end
      end

      context 'when step is delivery' do
        before { get :show, params: { id: :delivery } }

        it 'assigns :delivery to step' do
          expect(assigns(:step)).to eq(:delivery)
        end

        it 'renders the :delivery template' do
          expect(response).to render_template :delivery
        end
      end

      context 'when step is payment' do
        before { get :show, params: { id: :payment } }

        it 'assigns :payment to step' do
          expect(assigns(:step)).to eq(:payment)
        end

        it 'renders the :payment template' do
          expect(response).to render_template :payment
        end
      end

      context 'when step is confirm' do
        before { get :show, params: { id: :confirm } }

        it 'assigns :confirm to step' do
          expect(assigns(:step)).to eq(:confirm)
        end

        it 'renders the :confirm template' do
          expect(response).to render_template :confirm
        end
      end

      context 'when step is complete' do
        before { get :show, params: { id: :complete } }

        it 'clear session order_id' do
          expect(session[:order_id]).to be_nil
        end

        it 'assigns :complete to step' do
          expect(assigns(:step)).to eq(:complete)
        end

        it "renders the :complete template" do
          expect(response).to render_template :complete
        end
      end
    end

    describe 'PUT #update' do
      context "when step is address" do
        context "when data valid" do

          it "saves address" do
            expect do
              put :update, params: { id: :address, billing: attributes_for(:address,
                                                            address_type: "both") }
            end.to change(ShoppingCart::Address, :count).by(1)
          end

          it "redirect to :delivery step" do
            put :update, params: { id: :address, billing: attributes_for(:address,
                                                          address_type: "both") }
            expect(response).to redirect_to checkout_path(:delivery)
          end
        end

        context "when data invalid" do

          it "does not save address" do
            expect {
              put :update, params: { id: :address, billing: attributes_for(:address, zip: "qwe",
                                                            address_type: "both") }
            }.not_to change(ShoppingCart::Address, :count)
          end

          it "renders the :address template" do
            put :update, params: { id: :address, billing: attributes_for(:address, zip: "qwe",
                                                          address_type: "both") }
            expect(response).to render_template :address
          end
        end
      end

      context "when step is delivery" do
        context "when data valid" do
          before { put :update, params: { id: :delivery, delivery: delivery.id } }
          let(:delivery) { create(:delivery)}

          it "saves delivery to order" do
            expect(order.reload.delivery).to eq(delivery)
          end

          it "redirect to :payment step" do
            expect(response).to redirect_to checkout_path(:payment)
          end
        end

        context "when data invalid" do
          before { put :update, params: { id: :delivery } }

          it "does not save delivery to order" do
            expect(order.reload.delivery).to be_nil
          end

          it "renders :delivery step" do
            expect(response).to render_template :delivery
          end
        end
      end

      context "when step is payment" do
        context "when data valid" do

          it "saves credit card" do
            expect{
              put :update, params: { id: :payment, credit_card: attributes_for(:credit_card) }
            }.to change(ShoppingCart::CreditCard, :count).by(1)
          end

          it "saves credit card to order" do
            put :update, params: { id: :payment, credit_card: attributes_for(:credit_card) }
            expect(order.reload.credit_card).not_to be_nil
          end

          it "redirect to :confirm step" do
            put :update, params: { id: :payment, credit_card: attributes_for(:credit_card) }
            expect(response).to redirect_to checkout_path(:confirm)
          end
        end

        context "when data invalid" do

          it "saves credit card" do
            expect{
              put :update, params: { id: :payment, credit_card: attributes_for(:credit_card,
                                                                cvv: "qwe") }
            }.not_to change(ShoppingCart::CreditCard, :count)
          end

          it "does not save credit card to order" do
            put :update, params: { id: :payment, credit_card: attributes_for(:credit_card,
                                                                cvv: "qwe") }
            expect(order.reload.credit_card).to be_nil
          end

          it "renders :payment step" do
            put :update, params: { id: :payment, credit_card: attributes_for(:credit_card,
                                                                cvv: "qwe") }
            expect(response).to render_template :payment
          end
        end
      end

      context "when step is confirm" do
        it "change order state" do
          expect{
            put :update, params: { id: :confirm }
          }.to change(order, :state)
        end

        it "redirect to :complete step" do
          put :update, params: { id: :confirm }
          expect(response).to redirect_to checkout_path(:complete)
        end
      end
    end
  end
end
