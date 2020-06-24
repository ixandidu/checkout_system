require 'ostruct'

class Checkout
  def initialize(rules)
    @rules = rules
    @basket = []
  end

  def scan(item)
    @basket << item
  end

  def total
    @basket.sum(&:price)
  end
end

RSpec.describe 'Checkout System' do
  context 'with items A, B, C, and D' do
    let(:item_a) { OpenStruct.new(item: 'A', price: 30) }
    let(:item_b) { OpenStruct.new(item: 'B', price: 20) }
    let(:item_c) { OpenStruct.new(item: 'C', price: 50) }
    let(:item_d) { OpenStruct.new(item: 'D', price: 15) }

    context 'and promotions for item A, item B, and basket discount' do
      let(:item_a_promotion) { OpenStruct.new(item: 'A', count: 3, price: 75) }
      let(:item_b_promotion) { OpenStruct.new(item: 'B', count: 2, price: 35) }
      let(:basket_promotion) { OpenStruct.new(total: 150, discount: 20) }

      context 'and items A, B, C in the basket' do
        describe Checkout, '#total' do
          it 'equal the sum of item price in the basket' do
            checkout = Checkout.new([
              item_a_promotion,
              item_b_promotion,
              basket_promotion
            ])
            checkout.scan(item_a)
            checkout.scan(item_b)
            checkout.scan(item_c)

            expect(checkout.total).to eq(
              item_a.price + item_b.price + item_c.price
            )
          end
        end
      end

      context 'and items B, A, B, A, A in the basket'
      context 'and items C, B, A, A, D, A, B in the basket'
      context 'and items C, A, D, A, A the basket'
    end
  end
end
