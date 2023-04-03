# frozen_string_literal: true

require_relative 'stock'
require_relative 'coins_manager'
class VendingMachine
  attr_accessor :coin_manager, :stock

  class ProductOutOfStockError < StandardError
    def initialize(msg = 'Sorry, this product is out of stock')
      super
    end
  end

  class InvalidProductIdError < StandardError
    def initialize(msg = 'Invalid product. Please select a valid product ID.')
      super
    end
  end

  class NotEnoughMoneyError < StandardError
    def initialize(msg = 'Not enough money. Please insert more coins.')
      super
    end
  end

  class NotEnoughChangeError < StandardError
    def initialize(msg = 'Not enough change in the machine. Please try a different combination of coins or a different product.')
      super
    end
  end

  class InvalidCoinError < StandardError
  end

  def initialize(stock:, coins:)
    @stock = stock
    @coin_manager = CoinsManager.new(coins)
  end

  def buy_product(product, inserted_coins)
    validate_purchase(product:, inserted_coins:)

    stock.update_stock(product)
    coin_manager.restock_coins(inserted_coins)
    coin_manager.calculate_change(price: product.price, inserted_coins:)
  end

  def invalid_product_id?(product_id)
    stock.product_by_id(product_id).nil?
  end

  def find_product_by_id(product_id)
    stock.products.find { |product| product.id == product_id }
  end

  private

  def validate_purchase(product:, inserted_coins:)
    raise InvalidProductIdError if stock.invalid_product?(product)
    raise ProductOutOfStockError if stock.out_of_stock?(product)
    raise NotEnoughMoneyError if not_enough_money?(product:, money: inserted_coins&.sum)
    raise NotEnoughChangeError if coin_manager.not_enough_change?(price: product.price, inserted_coins:)
  end

  def not_enough_money?(product:, money:)
    money < product.price
  end
end
