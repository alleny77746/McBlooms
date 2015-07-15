class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  field :quantity, type: Integer, default: 0
  field :price_id, type: BSON::ObjectId
  field :price_amount, type: Money, default: 0

  validates :quantity, numericality: {greater_than_or_equal_to: 0}
  validates :product_id, presence: true

  embedded_in :itemable, polymorphic: true

  belongs_to :product

  def price
    return @price if @price && @price.id == price_id #prevents bad caching bug
    self.product = Product.find(:prices => {id: price_id}) if product.nil?
    @price = product.prices.find(price_id)
  end
  def price=new_price
    self.price_id = new_price.id
  end

  def price_id= new_price_id
    write_attribute(:price_id, new_price_id)
  end

  def price_amount
    @price_amount ||= Money.new(read_attribute(:price_amount))
    self.price_amount = @price_amount = price.amount if @price_amount.nil? || @price_amount <= 0
    @price_amount
  end

  def total
    total = price.amount * quantity
    total >= 0 ? total : 0
  end

  class << self
    def build_from(price, quantity = 1)
      Item.new(price: price, product: price.product, price_amount: price.amount, quantity: quantity)
    end
  end


  #######
  private
  #######

end