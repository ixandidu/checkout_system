require 'scanned_item'
require 'promotion'

class Checkout
  def initialize(promotions)
    @scanned_items = []
    @promotions = promotions
  end

  def scan(item)
    scanned_item = @scanned_items.find { |i| i.item == item }
    return scanned_item.rescan && @scanned_items if scanned_item

    @scanned_items << ScannedItem.new(item)
  end

  def total
    Promotion.apply(@promotions, @scanned_items)
  end
end
