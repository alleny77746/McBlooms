class Order
  include Mongoid::Document
  include Mongoid::Timestamps

  field :order_number, type: String

  belongs_to :user
  has_one :cart

  embeds_many :items,
              as: :itemable

  embeds_one :billing_address, class_name: "Address", as: :addressable, cascade_callbacks: true
  embeds_one :shipping_address, class_name: "Address", as: :addressable, cascade_callbacks: true


  validates :user_id, presence: true

  state_machine :state, initial: :pending do
    event :paid do
      transition :pending => :ordered
    end
  end

  class << self
    def build_from(cart)
      order = Order.new
      order.build_from(cart)
      order
    end
  end

  def build_from(cart)
    self.cart = cart
    self.user = cart.user
    clone_items(cart.items)
    clone_addresses(cart)
  end

  #TODO, create module for item controls (removed duplication in cart and order)
  def total
    items.inject(0.0){|sum, item| sum += (item.price_amount.to_f * item.quantity) }
  end

  #######
  private
  #######

  def clone_addresses(cart)
    self.billing_address = Address.new(cart.billing_address.attributes.except("_id")) if cart.billing_address.present?
    self.shipping_address = Address.new(cart.shipping_address.attributes.except("_id")) if cart.shipping_address.present?
  end

  def clone_items(items)
    items.each do |item|
      self.items << Item.new(item.attributes.except("_id").merge(price_amount: item.price.amount))
    end
  end
end
