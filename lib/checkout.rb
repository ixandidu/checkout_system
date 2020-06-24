require 'scanned_item'

class Checkout
  def initialize(promotions)
    @scanned_items = []

    @item_promotions = promotions.filter do |promotion|
      promotion.is_a?(Promotion::Item)
    end

    @basket_promotions = promotions.filter do |promotion|
      promotion.is_a?(Promotion::Basket)
    end
  end

  def scan(item)
    if (scanned_item = @scanned_items.find { |i| i.item == item })
      scanned_item.increment!
    else
      @scanned_items << ScannedItem.new(item)
    end
  end

  def total
    @item_promotions.each do |item_promotion|
      item_promotion.apply(@scanned_items)
    end

    @basket_promotions.sum do |basket_promotion|
      basket_promotion.apply(
        @scanned_items.sum { |item| item.sale_price || item.normal_price }
      )
    end
  end
end
