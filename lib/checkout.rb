require 'scanned_item'
require 'promotion'
require 'promotion_calculator'

class Checkout
  def initialize(promotions)
    @scanned_items = []
    @promotion_calculator = PromotionCalculator.new(promotions)
  end

  def scan(item)
    scanned_item = @scanned_items.find { |i| i.item == item }
    return scanned_item.rescan && @scanned_items if scanned_item

    @scanned_items << ScannedItem.new(item)
  end

  def total
    @promotion_calculator.calculate_total(@scanned_items)
  end
end
