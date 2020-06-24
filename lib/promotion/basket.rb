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
end
