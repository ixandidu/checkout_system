require 'item'
require 'checkout'

RSpec.describe Checkout, '#total' do
  let(:a) { Item.new(name: 'A', price: 30) }
  let(:b) { Item.new(name: 'B', price: 20) }
  let(:c) { Item.new(name: 'C', price: 50) }
  let(:d) { Item.new(name: 'D', price: 15) }
  let(:promotion_a) { Promotion::Item.new(item: a, quantity: 3, price: 75) }
  let(:promotion_b) { Promotion::Item.new(item: b, quantity: 2, price: 35) }
  let(:promotion_basket_1) { Promotion::Basket.new(total: 150, discount: 20) }
  let(:promotion_basket_2) { Promotion::Basket.new(total: 140, discount: 5) }

  subject { checkout.total }

  context 'with promotions' do
    let(:checkout) { Checkout.new(promotions) }
    let(:promotions) do
      [promotion_a, promotion_b, promotion_basket_1, promotion_basket_2]
    end

    context 'with items A, B, C in the basket' do
      before { [a, b, c].each { |item| checkout.scan(item) } }
      it     { is_expected.to eq(a.price + b.price + c.price) }
    end

    context 'with items B, A, B, A, A in the basket' do
      before { [b, a, b, a, a].each { |item| checkout.scan(item) } }
      it     { is_expected.to eq(promotion_a.price + promotion_b.price) }
    end

    context 'with items C, B, A, A, D, A, B in the basket' do
      before { [c, b, a, a, d, a, b].each { |item| checkout.scan(item) } }
      it 'is expected to eq 150' do
        is_expected.to eq(
          [c.price, promotion_a.price, promotion_b.price, d.price].sum -
          (promotion_basket_1.discount + promotion_basket_2.discount)
        )
      end
    end

    context 'with items C, A, D, A, A the basket' do
      before { [c, a, d, a, a].each { |item| checkout.scan(item) } }
      it     { is_expected.to eq(c.price + promotion_a.price + d.price) }
    end

    context 'with items C, A, D, A, A, A the basket' do
      before { [c, a, d, a, a, a].each { |item| checkout.scan(item) } }
      it 'is expected to eq 145' do
        is_expected.to eq(
          [c.price, promotion_a.price, d.price, a.price].sum -
          (promotion_basket_1.discount + promotion_basket_2.discount)
        )
      end
    end
  end
end
