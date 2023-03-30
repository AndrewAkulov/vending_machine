require_relative 'spec_helper'

RSpec.describe VendingMachineApp do
  let(:initial_stock) { Stock.new({ Product.new(id: 1, name: 'Soda', price: 3.5) => 10 }) }
  let(:initial_coins) { { 5.0 => 1, 3.0 => 1, 2.0 => 1, 1.0 => 1, 0.5 => 1, 0.25 => 1 } }
  let(:vending_machine) { VendingMachine.new(stock: initial_stock, coins: initial_coins) }
  subject(:vending_machine_app) { VendingMachineApp.new(vending_machine) }

  describe '#run' do
    let(:product) { initial_stock.products.first }

    before do
      allow(vending_machine_app).to receive(:puts)
      allow(vending_machine_app).to receive(:gets).and_return(product.id.to_s, '5', 'exit')
    end

    it 'displays available products' do
      expect(vending_machine_app).to receive(:puts).with('Available products:')
      vending_machine_app.run
    end

    it 'gets a product from the user' do
      expect(vending_machine_app).to receive(:gets).and_return(product.id.to_s)
      vending_machine_app.run
    end

    it 'gets inserted coins from the user' do
      expect(vending_machine_app).to receive(:gets).and_return('3,2')
      vending_machine_app.run
    end

    it 'processes a purchase with the vending machine' do
      expect(vending_machine).to receive(:buy_product).with(product, [5])
      vending_machine_app.run
    end

    it 'displays the result of the purchase' do
      expect(vending_machine_app).to receive(:puts).with("You bought the product.")
      allow(vending_machine_app).to receive(:gets).and_return('1', '5')
      vending_machine_app.run
    end
  end
end
