require_relative 'spec_helper'

RSpec.describe CoinsManager do
  let(:initial_coins) { { 5 => 10, 3 => 5, 2 => 5, 1 => 10, 0.5 => 5, 0.25 => 10 } }
  subject(:coins_manager) { CoinsManager.new(initial_coins) }

  describe '#valid_coin?' do
    subject(:coins_manager) { described_class.new(coins) }
    let(:coins) { { 1 => 10, 0.5 => 5 } }

    it 'returns true for a valid coin' do
      expect(coins_manager.valid_coin?(1)).to be_truthy
    end

    it 'returns false for an invalid coin' do
      expect(coins_manager.valid_coin?(7)).to be_falsy
    end

    it 'returns false for a non-numeric coin' do
      expect(coins_manager.valid_coin?('invalid')).to be_falsy
    end

    it 'returns false for a nil coin' do
      expect(coins_manager.valid_coin?(nil)).to be_falsy
    end
  end

  describe '#update_coins' do
    let(:inserted_coins) { [5, 3, 1, 0.5] }

    it 'updates the coins inventory' do
      coins_manager.restock_coins(inserted_coins)
      expect(coins_manager.instance_variable_get(:@coins)).to eq({ 5 => 11, 3 => 6, 2 => 5, 1 => 11, 0.5 => 6, 0.25 => 10 })
    end
  end

  describe '#calculate_change' do
    context 'when enough change is available' do
      let(:inserted_coins) { [5, 3] }
      let(:price) { 6.5 }

      it 'calculates the correct change' do
        change = coins_manager.calculate_change(inserted_coins: inserted_coins, price: price)
        expect(change).to eq({ 1 => 1, 0.5 => 1 })
      end

      it 'returns change using the minimum number of coins' do
        change = coins_manager.calculate_change(inserted_coins: inserted_coins, price: price)
        total_coins = change.values.sum
        expect(total_coins).to eq 2
      end
    end

    context 'when not enough change is available' do
      let(:initial_coins) { { 5 => 10, 3 => 5 } }
      let(:inserted_coins) { [5, 5, 5] }
      let(:price) { 11 }

      it 'returns nil' do
        change = coins_manager.calculate_change(inserted_coins: inserted_coins, price: price)
        expect(change).to be_nil
      end
    end
  end

  describe '#not_enough_change?' do
    context 'when enough change is available' do
      let(:inserted_coins) { [5, 3] }
      let(:price) { 6.5 }

      it 'returns false' do
        result = coins_manager.not_enough_change?(inserted_coins: inserted_coins, price: price)
        expect(result).to be_falsey
      end
    end

    context 'when not enough change is available' do
      let(:initial_coins) { { 5 => 10, 3 => 5 } }
      let(:inserted_coins) { [5, 5, 5] }
      let(:price) { 11 }

      it 'returns true' do
        result = coins_manager.not_enough_change?(inserted_coins: inserted_coins, price: price)
        expect(result).to be_truthy
      end
    end
  end
end
