class ScannedItem
  attr_accessor :sale_price
  attr_reader :item, :qty, :normal_price

  def initialize(item)
    @item = item
    @qty = 1
    @normal_price = item.price
  end

  def increment!
    @qty += 1
    @normal_price += item.price
  end
end
