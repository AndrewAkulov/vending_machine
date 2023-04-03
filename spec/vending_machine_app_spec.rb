# frozen_string_literal: true

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
      allow(vending_machine_app).to receive(:gets).and_return(product_id, inserted_coins, 'exit')
    end

    after do
      vending_machine_app.run
    end

    context 'when product id is correct' do
      let(:product_id) { product.id.to_s }
      let(:inserted_coins) { '5' }

      context 'when enough coins are inserted' do
        context 'without change' do
          let(:inserted_coins) { '2,1,0.5' }

          it 'successfully purchases product' do
            expect(vending_machine_app).to receive(:puts).with('Welcome to the Vending Machine!')
            expect(vending_machine_app).to receive(:puts).with('Available products:')
            displayed_product = "ID: #{product.id}, Name: #{product.name}, Price: #{product.price}, Quantity: #{initial_stock.product_quantity(product)}"
            expect(vending_machine_app).to receive(:puts).with(displayed_product)
            expect(vending_machine_app).to receive(:puts).with("Please select a product by entering its ID (or type 'exit' to quit):")
            expect(vending_machine_app).to receive(:puts).with('Please insert coins separated by commas (0.25, 0.5, 1, 2, 3, 5):')
            expect(vending_machine_app).to receive(:puts).with('Thank you for your purchase!')
          end
        end
      end

      context 'when inserted more coins than needed' do
        let(:inserted_coins) { '5' }

        it 'successfully purchases product and return change' do
          expect(vending_machine_app).to receive(:puts).with('Welcome to the Vending Machine!')
          expect(vending_machine_app).to receive(:puts).with('Available products:')
          displayed_product = "ID: #{product.id}, Name: #{product.name}, Price: #{product.price}, Quantity: #{initial_stock.product_quantity(product)}"
          expect(vending_machine_app).to receive(:puts).with(displayed_product)
          expect(vending_machine_app).to receive(:puts).with("Please select a product by entering its ID (or type 'exit' to quit):")
          expect(vending_machine_app).to receive(:puts).with('Please insert coins separated by commas (0.25, 0.5, 1, 2, 3, 5):')
          expect(vending_machine_app).to receive(:puts).with('Your change is:')
          expect(vending_machine_app).to receive(:puts).with('1.0 * 1')
          expect(vending_machine_app).to receive(:puts).with('0.5 * 1')
          expect(vending_machine_app).to receive(:puts).with('Thank you for your purchase!')
        end
      end

      context 'when not enough coins are inserted' do
        let(:inserted_coins) { '3' }
        let(:additional_coins) { '1' }

        before do
          allow(vending_machine_app).to receive(:puts)
          allow(vending_machine_app).to receive(:gets).and_return(product_id, inserted_coins, additional_coins, 'exit')
        end

        it 'asks for more coins and successfully purchases product' do
          expect(vending_machine_app).to receive(:puts).with('Welcome to the Vending Machine!')
          expect(vending_machine_app).to receive(:puts).with('Available products:')
          displayed_product = "ID: #{product.id}, Name: #{product.name}, Price: #{product.price}, Quantity: #{initial_stock.product_quantity(product)}"
          expect(vending_machine_app).to receive(:puts).with(displayed_product)
          expect(vending_machine_app).to receive(:puts).with("Please select a product by entering its ID (or type 'exit' to quit):")
          expect(vending_machine_app).to receive(:puts).with('Please insert coins separated by commas (0.25, 0.5, 1, 2, 3, 5):')
          expect(vending_machine_app).to receive(:puts).with('Not enough money. Please insert more coins.')
          expect(vending_machine_app).to receive(:puts).with('Please insert coins separated by commas (0.25, 0.5, 1, 2, 3, 5):')
          expect(vending_machine_app).to receive(:puts).with('Your change is:')
          expect(vending_machine_app).to receive(:puts).with('0.5 * 1')
          expect(vending_machine_app).to receive(:puts).with('Thank you for your purchase!')
        end
      end
    end

    context 'when product id is incorrect' do
      let(:product_id) { '10' }
      let(:inserted_coins) { '10' }

      it 'should display that product is incorrect' do
        expect(vending_machine_app).to receive(:puts).with('Welcome to the Vending Machine!')
        expect(vending_machine_app).to receive(:puts).with('Available products:')
        displayed_product = "ID: #{product.id}, Name: #{product.name}, Price: #{product.price}, Quantity: #{initial_stock.product_quantity(product)}"
        expect(vending_machine_app).to receive(:puts).with(displayed_product)
        expect(vending_machine_app).to receive(:puts).with('Invalid product. Please select a valid product ID.')
      end
    end
  end
end
