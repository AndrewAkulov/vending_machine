# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe Stock do
  let(:product) { Product.new(id: 1, name: 'Soda', price: 3.5) }
  let(:initial_stock) { Stock.new({ product => 10 }) }
  subject(:stock) { initial_stock }

  describe '#initialize' do
    it 'creates a Stock instance with products' do
      expect(stock.products).to eq([product])
    end
  end

  describe '#product_quantity' do
    it 'returns the quantity of a product' do
      expect(stock.product_quantity(product)).to eq(10)
    end
  end

  describe '#product_by_id' do
    context 'when product with id exists in the stock' do
      it 'returns the product' do
        expect(stock.product_by_id(1)).to eq(product)
      end
    end

    context 'when product with id does not exist in the stock' do
      it 'returns nil' do
        expect(stock.product_by_id(3)).to be_nil
      end
    end
  end

  describe '#out_of_stock?' do
    it 'returns false if there is stock for a product' do
      expect(stock.out_of_stock?(product)).to be_falsey
    end

    it 'returns true if there is no stock for a product' do
      initial_stock = Stock.new({ product => 0 })
      expect(initial_stock.out_of_stock?(product)).to be_truthy
    end
  end

  describe '#update_stock' do
    context 'when the product is out of stock' do
      let(:initial_stock) { Stock.new({ product => 0 }) }

      it 'does not update the stock' do
        expect { stock.withdraw_product(product) }.not_to change { stock.product_quantity(product) }
      end
    end

    context 'when the product is in stock' do
      it 'updates the stock' do
        expect { stock.withdraw_product(product) }.to change { stock.product_quantity(product) }.by(-1)
      end
    end
  end

  describe '#invalid_product?' do
    let(:new_product) { Product.new(id: 2, name: 'Water', price: 1.5) }

    it 'returns false if the product is valid' do
      expect(stock.invalid_product?(product)).to be_falsey
    end

    it 'returns true if the product is invalid' do
      expect(stock.invalid_product?(new_product)).to be_truthy
    end
  end
end
