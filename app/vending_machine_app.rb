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
    @vending_machine.stock.products.find { |product| product.id == id }
  end

  def get_inserted_coins
    puts 'Please insert coins separated by commas (0.25, 0.5, 1, 2, 3, 5):'
    gets.chomp.split(',').map(&:to_f)
  end

  def process_purchase(product, inserted_coins)
    @vending_machine.buy_product(product, inserted_coins)
  rescue VendingMachine::InvalidProductIdError, VendingMachine::ProductOutOfStockError,
         VendingMachine::NotEnoughMoneyError, VendingMachine::NotEnoughChangeError,
         VendingMachine::InvalidCoinError => e
    e.message
  end

  def display_result(result)
    if result.is_a?(Hash)
      puts 'You bought the product.'
      puts 'Your change is:'
      result.each do |coin, count|
        puts "#{coin} * #{count}"
      end
      puts 'Thank you for your purchase!'
    else
      puts "#{result} \n\n\n"
    end
  end
end
