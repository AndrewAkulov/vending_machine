# frozen_string_literal: true

class VendingMachineApp
  def initialize(vending_machine)
    @vending_machine = vending_machine
  end

  def run
    loop do
      display_products
      product = get_product
      break if product.nil?

      inserted_coins = get_inserted_coins
      result = process_purchase(product, inserted_coins)

      display_result(result)
    end
  end

  private

  def display_products
    puts 'Welcome to the Vending Machine!'
    puts 'Available products:'
    @vending_machine.stock.products_quantities.each do |product, quantity|
      puts "ID: #{product.id}, Name: #{product.name}, Price: #{product.price}, Quantity: #{quantity}"
    end
  end

  def get_product
    puts "Please select a product by entering its ID (or type 'exit' to quit):"
    input = gets.chomp
    return if input.downcase == 'exit'

    id = input.to_i
    raise VendingMachine::InvalidProductIdError if @vending_machine.invalid_product_id?(id)

    @vending_machine.stock.products.find { |product| product.id == id }
  rescue VendingMachine::InvalidProductIdError, VendingMachine::NotEnoughMoneyError => e
    puts e.message.to_s
    get_product
  end

  def process_purchase(product, inserted_coins)
    loop do
      result = @vending_machine.buy_product(product, inserted_coins)
      return result if result.is_a?(Hash)

      display_result(result)
      inserted_coins += get_inserted_coins
      @vending_machine.buy_product(product, inserted_coins)

    rescue VendingMachine::NotEnoughMoneyError => e
      puts e.message.to_s
      inserted_coins += get_inserted_coins
    rescue VendingMachine::InvalidProductIdError,
           VendingMachine::ProductOutOfStockError,
           VendingMachine::NotEnoughChangeError => e
      puts e.message
    end
  end

  def display_result(result)
    puts 'You bought the product.'
    print_change(result)
    puts 'Thank you for your purchase!'
    puts "\n\n\n"
  end

  def print_change(result)
    return if result.nil? || result.empty?

    puts 'Your change is:'
    result.each do |coin, count|
      puts "#{coin} * #{count}"
    end
  end

  def get_inserted_coins
    loop do
      puts 'Please insert coins separated by commas (0.25, 0.5, 1, 2, 3, 5):'
      inserted_coins = gets.chomp.split(',').map(&:to_f)
      begin
        validate_inserted_coins(inserted_coins)
        return inserted_coins
      rescue VendingMachine::InvalidCoinError => e
        puts "#{e.message} Please insert valid coins."
      end
    end
  end

  def validate_inserted_coins(inserted_coins)
    return if inserted_coins.all? { |coin| @vending_machine.coin_manager.valid_coin?(coin) }

    raise VendingMachine::InvalidCoinError, 'Invalid coin. Please insert valid coins.'
  end
end
