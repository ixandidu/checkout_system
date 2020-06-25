require 'promotion'

class PromotionCalculator
  def initialize(promotions)
    @promotions = promotions.group_by(&:class)
  end

  def calculate_total(scanned_items)
    @promotions[Promotion::Item].each do |item_promotion|
      item_promotion.apply(scanned_items)
    end

    @promotions[Promotion::Basket].sum do |basket_promotion|
      basket_promotion.apply(
        scanned_items.sum(&:billable_amount)
      )
    end
  end
end
