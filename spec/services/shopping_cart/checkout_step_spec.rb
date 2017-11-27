module ShoppingCart
  RSpec.describe CheckoutStepService do
    let(:steps) { [:address, :delivery, :payment, :confirm, :complete] }
    let(:order) { create(:order) }
    subject { CheckoutStepService.new(steps, {}, order) }

    describe '#initialize' do
      it 'assigns steps to @steps' do
        expect(subject.instance_variable_get(:@steps)).to eq(steps)
      end

      it 'assigns params to @params' do
        expect(subject.instance_variable_get(:@params)).to be_empty
      end

      it 'assigns order to @order' do
        expect(subject.instance_variable_get(:@order)).to eq(order)
      end
    end

    describe '#set_current_step' do
      before(:all) {@order = create(:order, user: create(:user)) }
      subject { CheckoutStepService.new(steps, {}, @order) }

      it 'should return address' do
        expect(subject.set_current_step).to eq(:address)
      end

      it 'should return delivery' do
        @order.addresses.create(attributes_for(:address, address_type: "both"))
        expect(subject.set_current_step).to eq(:delivery)
      end

      it 'should return payment' do
        @order.update_attributes(delivery_id: 5)
        expect(subject.set_current_step).to eq(:payment)
      end

      it 'should return confirm' do
        @order.update_attributes(credit_card_id: 1)
        expect(subject.set_current_step).to eq(:confirm)
      end

      it 'should return complete' do
        @order.confirm
        expect(subject.set_current_step).to eq(:complete)
      end
    end
  end
end
