require 'rails_helper'

module ShoppingCart
  RSpec.describe ShoppingCart::OrdersController, type: :controller do
    routes { ShoppingCart::Engine.routes }

    let(:user) { create(:user, orders: [order]) }
    let(:order) { create(:order) }

    before do
      allow(controller).to receive(:authenticate_user!)
      allow_any_instance_of(CanCan::ControllerResource).to receive(:load_and_authorize_resource)
    end

    describe 'GET #index' do
      before do
        allow(controller).to receive(:current_user).and_return(user)
        get :index
      end

      it "assigns the requested orders to @orders" do
        expect(assigns(:orders)).to eq user.orders
      end

      it "renders the :index template" do
        expect(response).to render_template :index
      end
    end

    describe 'GET #show' do
      before { get :show, params: { id: order.id } }

      it "renders the :show template" do
        expect(response).to render_template :show
      end
    end
  end
end
