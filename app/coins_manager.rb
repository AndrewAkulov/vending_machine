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
    coins_sorted_descending = @coins.keys.sort.reverse
    change = {}

    coins_sorted_descending.each do |coin|
      count = get_max_coin_count(coin, remaining_change_needed)
      if count&.positive?
        change[coin] = count
        remaining_change_needed -= coin * count
      end
    end

    return if remaining_change_needed.nonzero? || !enough_change?(change)

    change
  end

  def not_enough_change?(inserted_coins:, price:)
    change = calculate_change(inserted_coins:, price:)
    change.nil?
  end

  private

  def get_max_coin_count(coin, change_needed)
    [(@coins[coin] || 0), (change_needed / coin).floor].min
  end

  def enough_change?(change)
    change.all? { |coin, count| @coins[coin] >= count }
  end
end
