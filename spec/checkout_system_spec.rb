require 'item'
require 'item_promotion'
require 'basket_promotion'
require 'checkout'

RSpec.describe 'Checkout System' do
  context 'given items A, B, C, and D exists' do
    let(:item_a) { Item.new(name: 'A', price: 30) }
    let(:item_b) { Item.new(name: 'B', price: 20) }
    let(:item_c) { Item.new(name: 'C', price: 50) }
    let(:item_d) { Item.new(name: 'D', price: 15) }

    context 'and promotional rules for item A, item B, and basket discount exists' do
      let(:item_a_promotion) do
        ItemPromotion.new(item: item_a, qty: 3, price: 75)
      end
      let(:item_b_promotion) do
        ItemPromotion.new(item: item_b, qty: 2, price: 35)
      end
      let(:basket_promotion) { BasketPromotion.new(total: 150, discount: 20) }

      describe Checkout, '#total' do
        context 'with all promotional rules applied' do
          let(:promotions) do
            [item_a_promotion, item_b_promotion, basket_promotion]
          end

          context 'and items A, B, C in the basket' do
            it 'is the sum of item price in the basket' do
              checkout = Checkout.new(promotions)
              checkout.scan(item_a)
              checkout.scan(item_b)
              checkout.scan(item_c)

              expect(checkout.total).to eq(
                item_a.price + item_b.price + item_c.price
              )
            end
          end

          context 'and items B, A, B, A, A in the basket' do
            it 'is the sum of item A and item B promotion price' do
              checkout = Checkout.new(promotions)
              checkout.scan(item_b)
              checkout.scan(item_a)
              checkout.scan(item_b)
              checkout.scan(item_a)
              checkout.scan(item_a)

              expect(checkout.total).to eq(
                item_a_promotion.price + item_b_promotion.price
              )
            end
          end

          context 'and items C, B, A, A, D, A, B in the basket' do
            it 'is the sum of item C price, item A and item B promotion price, and item D price, minus basket discount' do
              checkout = Checkout.new(promotions)
              checkout.scan(item_c)
              checkout.scan(item_b)
              checkout.scan(item_a)
              checkout.scan(item_a)
              checkout.scan(item_d)
              checkout.scan(item_a)
              checkout.scan(item_b)

              expect(checkout.total).to eq(
                item_c.price +
                  item_a_promotion.price +
                  item_b_promotion.price +
                  item_d.price -
                  basket_promotion.discount
              )
            end
          end

          context 'and items C, A, D, A, A the basket' do
            it 'is the sum of item C price, item A promotion price, and item D price' do
              checkout = Checkout.new(promotions)
              checkout.scan(item_c)
              checkout.scan(item_a)
              checkout.scan(item_d)
              checkout.scan(item_a)
              checkout.scan(item_a)

              expect(checkout.total).to eq(
                item_c.price + item_a_promotion.price + item_d.price
              )
            end
          end
        end
      end
    end
  end
end
