require_relative 'vending_machine_app'
require_relative 'vending_machine'
require_relative 'stock'
require_relative 'product'

product_1 = Product.new(id: 1, name: 'Soda', price: 2)
product_2 = Product.new(id: 2, name: 'Snickers', price: 6)
initial_stock = Stock.new({ product_1 => 10, product_2 => 5 })
initial_coins = { 5.0 => 1, 3.0 => 1, 2.0 => 1, 1.0 => 1, 0.5 => 1, 0.25 => 1 }
vending_machine = VendingMachine.new(stock: initial_stock, coins: initial_coins)

app = VendingMachineApp.new(vending_machine)
app.run