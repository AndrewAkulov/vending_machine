# Vending Machine

This is a simple command-line vending machine application that allows a user to purchase products by inserting coins.

## Features

- View available products and their quantities
- Insert coins to make a purchase
- Get change back after a purchase
- Handle invalid input gracefully
- Handle invalid coins gracefully
- Handle insufficient coins gracefully
- Handle insufficient change gracefully

## Usage

To use the vending machine, run the `main.rb` file in the command line. The vending machine will display a list of available products and their quantities. To make a purchase, enter the ID of the product you wish to purchase, followed by the coins you wish to insert, separated by commas. For example:

Please select a product by entering its ID (or type 'exit' to quit):

1

Please insert coins separated by commas (0.25, 0.5, 1, 2, 3, 5):

2, 1

You bought the product.
Your change is:
1.0 * 1


## Classes

This application is made up of the following classes:

- `Product`: Represents a product that can be purchased from the vending machine.
- `Stock`: Represents the stock of products in the vending machine.
- `CoinsManager`: Represents the coins inventory in the vending machine.
- `VendingMachine`: Represents the vending machine itself, which validates input, purchases products, and manages coins.
- `VendingMachineApp`: Represents the terminal application that interacts with the user.

## Testing

This application is tested using RSpec. To run the tests, navigate to the root directory of the application and run `rspec`.

## Contributing

Contributions to this application are welcome. If you would like to contribute, please submit a pull request.


