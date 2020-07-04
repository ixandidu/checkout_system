module Promotion
  Basket = Struct.new(:total, :discount, keyword_init: true) do
    def apply(basket_total)
      applicable?(basket_total) ? basket_total - discount : basket_total
    end

    private

    def applicable?(basket_total)
      basket_total > total
    end
  end

  Item = Struct.new(:item, :quantity, :price, keyword_init: true) do
    def apply(scanned_item)
      return unless applicable?(scanned_item)

      (scanned_item.quantity / quantity).times.sum { price } +
        (scanned_item.quantity % quantity).times.sum { item.price }
    end

    private

    def applicable?(scanned_item)
      scanned_item.item == item && scanned_item.quantity >= quantity
    end
  end
end
