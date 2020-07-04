class ScannedItem
  attr_reader :item, :quantity, :subtotal

  def initialize(item, promotion)
    @item = item
    @promotion = promotion
    @quantity = 0

    scan
  end

  def scan
    @quantity += 1
    @subtotal = @promotion&.apply(self) || item.price * @quantity
  end
end
