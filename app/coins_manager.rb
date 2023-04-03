# frozen_string_literal: true

class CoinsManager
  VALID_COINS = [0.25, 0.5, 1, 2, 3, 5].freeze

  attr_reader :coins

  def initialize(coins)
    @coins = coins
  end

  def valid_coin?(coin)
    VALID_COINS.include?(coin)
  end

  def restock_coins(inserted_coins)
    inserted_coins.each do |coin|
      raise VendingMachine::InvalidCoinError, "Invalid coin: #{coin}" if @coins[coin].nil?

      @coins[coin] += 1
    end
  end

  def calculate_change(inserted_coins:, price:)
    remaining_change_needed = inserted_coins.sum - price
    sorted_descending_coins = @coins.keys.sort.reverse
    change = {}

    sorted_descending_coins.each do |coin|
      coin_count = max_coin_count(coin, remaining_change_needed)
      next unless coin_count&.positive?

      change[coin] = coin_count
      remaining_change_needed -= coin * coin_count
    end

    change if remaining_change_needed.zero? && enough_change?(change)
  end

  def not_enough_change?(inserted_coins:, price:)
    calculate_change(inserted_coins:, price:).nil?
  end

  private

  def max_coin_count(coin, change_needed)
    [(@coins[coin] || 0), (change_needed / coin).floor].min
  end

  def enough_change?(change)
    change.all? { |coin, count| @coins[coin] >= count }
  end
end
