require 'scanned_item'
require 'promotion'

class Checkout
  def initialize(promotions)
    @scanned_items = []
    @promotions = promotions.group_by(&:class)
  end

  def scan(item)
    scanned_item = @scanned_items.find { |si| si.item == item }
    return scanned_item.scan if scanned_item

    promotion = @promotions[Promotion::Item].find { |pi| pi.item == item }
    @scanned_items << ScannedItem.new(item, promotion)
  end

  def total
    @promotions[Promotion::Basket].sum do |basket_promotion|
      basket_promotion.apply(
        @scanned_items.sum(&:subtotal)
      )
    end
  end
end
