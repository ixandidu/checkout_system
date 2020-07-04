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
    def apply(scanned_items)
      scanned_items.each do |scanned_item|
        next unless applicable?(scanned_item)

        (scanned_item.quantity / quantity).times { scanned_item.sale_price += price }
        (scanned_item.quantity % quantity).times do
          scanned_item.sale_price += scanned_item.price
        end
      end
    end

    private

    def applicable?(scanned_item)
      scanned_item.item == item && scanned_item.quantity >= quantity
    end
  end
end
