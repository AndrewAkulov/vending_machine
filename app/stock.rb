# frozen_string_literal: true

class Stock
  attr_reader :products

  def initialize(stock)
    @stock = stock
    @products = stock.keys
  end

  def product_quantity(product)
    @stock[product]
  end

  def product_by_id(id)
    @stock.keys.find { |product| product.id == id }
  end

  def products_quantities
    @stock
  end

  def out_of_stock?(product)
    @stock[product] < 1
  end

  def withdraw_product(product)
    return if out_of_stock?(product)

    @stock[product] -= 1
  end

  def invalid_product?(product)
    !@stock.key?(product)
  end
end
