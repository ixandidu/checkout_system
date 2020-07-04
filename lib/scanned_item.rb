require 'forwardable'

class ScannedItem
  extend Forwardable

  def_delegator :item, :price

  attr_accessor :sale_price
  attr_reader :item, :quantity, :normal_price

  def initialize(item)
    @item = item
    @quantity = 1
    @normal_price = item.price
    @sale_price = 0
  end

  def rescan
    @quantity += 1
    @normal_price += item.price
  end

  def billable_amount
    sale_price.zero? ? normal_price : sale_price
  end
end
