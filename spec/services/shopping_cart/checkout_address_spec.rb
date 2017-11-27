module ShoppingCart
  RSpec.describe CheckoutAddressService do
    let(:params) do
      ActionController::Parameters.new(billing: attributes_for(:address, address_type: "both"))
    end
    let(:order) { create(:order) }
    subject { CheckoutAddressService.new(order, params) }

    describe '#initialize' do
      it 'assigns params to @params' do
        expect(subject.instance_variable_get(:@params)).to eq(params)
      end

      it 'assigns order to @order' do
        expect(subject.instance_variable_get(:@order)).to eq(order)
      end
    end

    describe '#create_or_update_address' do
      context "when address doesn't exist" do
        it 'saves address to db' do
          subject.create_or_update_address
          expect(subject.instance_variable_get(:@order).addresses).not_to be_nil
        end
      end

      context 'when address exists' do
        it "doesn't save address to db" do
          order.addresses.create(attributes_for(:address))
          expect {
            subject.create_or_update_address
          }.not_to change(ShoppingCart::Address, :count)
        end
      end
    end
  end
end
