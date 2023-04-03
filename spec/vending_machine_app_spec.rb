# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe VendingMachineApp do
  let(:initial_stock) { Stock.new({ Product.new(id: 1, name: 'Soda', price: 3.5) => 10 }) }
  let(:initial_coins) { { 5.0 => 1, 3.0 => 1, 2.0 => 1, 1.0 => 1, 0.5 => 1, 0.25 => 1 } }
  let(:vending_machine) { VendingMachine.new(stock: initial_stock, coins: initial_coins) }
  subject(:vending_machine_app) { VendingMachineApp.new(vending_machine) }

  describe '#run' do
    let(:product) { initial_stock.products.first }

    context 'when enough coins are inserted' do
      context 'without change' do
        before do
          allow(vending_machine_app).to receive(:puts)
          allow(vending_machine_app).to receive(:gets).and_return('1', '2,1,0.5', 'exit')
        end


        it 'successfully purchases product' do
          expect(vending_machine_app).to receive(:puts).with('Welcome to the Vending Machine!')
          expect(vending_machine_app).to receive(:puts).with('Available products:')
          displayed_product = "ID: #{product.id}, Name: #{product.name}, Price: #{product.price}, Quantity: #{initial_stock.product_quantity(product)}"
          expect(vending_machine_app).to receive(:puts).with("Please select a product by entering its ID (or type 'exit' to quit):")
          expect(vending_machine_app).to receive(:puts).with('Please insert coins separated by commas (0.25, 0.5, 1, 2, 3, 5):')
          expect(vending_machine_app).to receive(:puts).with('Thank you for your purchase!')
          vending_machine_app.run
        end

      end
    end
  end
end
