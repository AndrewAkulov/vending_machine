# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe VendingMachine do
  let(:initial_stock) { Stock.new({ Product.new(id: 1, name: 'Soda', price: 3.5) => 10 }) }
  let(:initial_coins) { { 5 => 10, 3 => 5, 2 => 5, 1 => 10, 0.5 => 5, 0.25 => 10 } }
  subject(:vending_machine) { VendingMachine.new(stock: initial_stock, coins: initial_coins) }

  describe '#buy_product' do
    let(:product) { initial_stock.products.first }
    let(:inserted_coins) { [5] }

    context 'when the purchase is valid' do
      it 'returns the correct change' do
        change = vending_machine.buy_product(product, inserted_coins)
        expect(change).to eq({ 1 => 1, 0.5 => 1 })
      end

      it 'updates the stock' do
        expect { vending_machine.buy_product(product, inserted_coins) }.to change {
                                                                             initial_stock.product_quantity(product)
                                                                           }.by(-1)
      end

      it 'updates the coins inventory' do
        vending_machine.buy_product(product, inserted_coins)
        expect(vending_machine.coin_manager.coins).to eq({ 5 => 11, 3 => 5, 2 => 5, 1 => 10, 0.5 => 5, 0.25 => 10 })
      end
    end

    context 'when the purchase is invalid' do
      context 'when the product is invalid' do
        let(:invalid_product) { Product.new(id: 2, name: 'Not in stock', price: 2) }

        it 'raises an InvalidProductIdError' do
          expect do
            vending_machine.buy_product(invalid_product, inserted_coins)
          end.to raise_error(VendingMachine::InvalidProductIdError)
        end
      end

      context 'when the product is out of stock' do
        let(:initial_stock) { Stock.new({ Product.new(id: 1, name: 'Soda', price: 3.5) => 0 }) }

        it 'raises a ProductOutOfStockError' do
          expect do
            vending_machine.buy_product(product, inserted_coins)
          end.to raise_error(VendingMachine::ProductOutOfStockError)
        end
      end

      context 'when not enough money is inserted' do
        let(:inserted_coins) { [1] }

        it 'raises a NotEnoughMoneyError' do
          expect do
            vending_machine.buy_product(product, inserted_coins)
          end.to raise_error(VendingMachine::NotEnoughMoneyError)
        end
      end

      context 'when not enough change is available' do
        let(:initial_coins) { { 5 => 10, 3 => 5 } }
        let(:inserted_coins) { [5, 5, 5] }

        it 'raises a NotEnoughChangeError' do
          expect do
            vending_machine.buy_product(product, inserted_coins)
          end.to raise_error(VendingMachine::NotEnoughChangeError)
        end
      end
    end
  end
end
