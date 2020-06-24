module Promotion
  Item = Struct.new(:item, :qty, :price, keyword_init: true) do
    def apply(scanned_items)
      scanned_items.each do |scanned_item|
        next unless applicable?(scanned_item)

        scanned_item.sale_price = 0

        (scanned_item.qty / qty).times { scanned_item.sale_price += price }
        (scanned_item.qty % qty).times do
          scanned_item.sale_price += scanned_item.price
        end
      end
    end

    private

    def applicable?(scanned_item)
      scanned_item.item == item && scanned_item.qty >= qty
    end
  end
end
