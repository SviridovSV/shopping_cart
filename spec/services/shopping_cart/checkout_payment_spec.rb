module ShoppingCart
  RSpec.describe CheckoutPaymentService do
    let(:params) do
      ActionController::Parameters.new(credit_card: attributes_for(:credit_card))
    end
    let(:order) { create(:order) }
    subject { CheckoutPaymentService.new(order, params) }

    describe '#initialize' do
      it 'assigns params to @params' do
        expect(subject.instance_variable_get(:@params)).to eq(params)
      end

      it 'assigns order to @order' do
        expect(subject.instance_variable_get(:@order)).to eq(order)
      end
    end

    describe '#create_or_update_card' do
      context "when credit card doesn't exist" do
        it 'saves card to db' do
          expect {
            subject.create_or_update_card
          }.to change(ShoppingCart::CreditCard, :count).by(1)
        end
      end

      context 'when credit card exists' do
        it "doesn't save card to db" do
          order.create_credit_card(attributes_for(:credit_card))
          expect {
            subject.create_or_update_card
          }.not_to change(ShoppingCart::CreditCard, :count)
        end
      end
    end
  end
end
