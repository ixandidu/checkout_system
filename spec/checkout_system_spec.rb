require 'ostruct'

class Checkout
  def initialize(rules)
    @rules = rules
    @scanned_items = []
  end

  def scan(item)
    if (scanned_item = @scanned_items.find { |i| i.item == item.item })
      scanned_item.qty += 1
      scanned_item.total_price += item.price
    else
      @scanned_items << OpenStruct.new(**item.to_h, qty: 1, total_price: item.price)
    end
  end

  def total
    # Item Promotions
    @rules.filter { |rule| rule.total.nil? }.each do |item_promotion|
      scanned_item = @scanned_items.find { |item| item.item == item_promotion.item }

      next unless scanned_item

      if scanned_item.qty >= item_promotion.qty
        scanned_item.sale_price = 0

        (scanned_item.qty / item_promotion.qty).times do
          scanned_item.sale_price += item_promotion.price
        end

        (scanned_item.qty % item_promotion.qty).times do
          scanned_item.sale_price += scanned_item.price
        end
      end
    end

    basket_total = @scanned_items.sum { |item| item.sale_price || item.total_price }

    # Basket promotions
    @rules.filter { |rule| rule.item.nil? }.each do |basket_promotion|
      next if basket_total <= basket_promotion.total

      basket_total -= basket_promotion.discount
    end

    basket_total
  end
end

RSpec.describe 'Checkout System' do
  context 'given items A, B, C, and D exists' do
    let(:item_a) { OpenStruct.new(item: 'A', price: 30) }
    let(:item_b) { OpenStruct.new(item: 'B', price: 20) }
    let(:item_c) { OpenStruct.new(item: 'C', price: 50) }
    let(:item_d) { OpenStruct.new(item: 'D', price: 15) }

    context 'and promotions for item A, item B, and basket discount exists' do
      let(:item_a_promotion) { OpenStruct.new(item: 'A', qty: 3, price: 75) }
      let(:item_b_promotion) { OpenStruct.new(item: 'B', qty: 2, price: 35) }
      let(:basket_promotion) { OpenStruct.new(total: 150, discount: 20) }

      describe Checkout, '#total' do
        context 'with all promotional rules applied' do
          let(:rules) { [item_a_promotion, item_b_promotion, basket_promotion] }

          context 'and items A, B, C in the basket' do
            it 'is the sum of item price in the basket' do
              checkout = Checkout.new(rules)
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
              checkout = Checkout.new(rules)
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
              checkout = Checkout.new(rules)
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
              checkout = Checkout.new(rules)
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
