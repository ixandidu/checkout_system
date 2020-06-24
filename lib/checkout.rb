require 'ostruct'

class Checkout
  def initialize(rules)
    @rules = rules
    @scanned_items = []
  end

  def scan(item)
    if (scanned_item = @scanned_items.find { |i| i.item == item })
      scanned_item.qty += 1
      scanned_item.total_price += item.price
    else
      @scanned_items << OpenStruct.new(item: item, qty: 1, total_price: item.price)
    end
  end

  def total
    # Item Promotions
    @rules.filter { |rule| rule.is_a?(ItemPromotion) }.each do |item_promotion|
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
    @rules.filter { |rule| rule.is_a?(BasketPromotion) }.each do |basket_promotion|
      next if basket_total <= basket_promotion.total

      basket_total -= basket_promotion.discount
    end

    basket_total
  end
end


