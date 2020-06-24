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

  Item = Struct.new(:item, :qty, :price, keyword_init: true) do
    def apply(scanned_items)
      scanned_items.each do |scanned_item|
        next unless applicable?(scanned_item)

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

  def self.apply(promotions, scanned_items)
    promotions = promotions.group_by(&:class)

    promotions[Item].each do |item_promotion|
      item_promotion.apply(scanned_items)
    end

    promotions[Basket].sum do |basket_promotion|
      basket_promotion.apply(scanned_items.sum(&:billable_amount))
    end
  end
end
