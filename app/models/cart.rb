class Cart
  include Mongoid::Document
  include Mongoid::Timestamps
  include Cart::Register
  include Cart::Checkout

  belongs_to :user
  belongs_to :order

  embeds_many :items,
              as: :itemable

  embeds_one :billing_address, class_name: "Address", as: :addressable, cascade_callbacks: true
  embeds_one :shipping_address, class_name: "Address", as: :addressable, cascade_callbacks: true

  before_save :clear_zero_quantity_items
  delegate :empty?, to: :items

  accepts_nested_attributes_for :items, allow_destroy: true, :reject_if => :all_blank
  accepts_nested_attributes_for :billing_address
  accepts_nested_attributes_for :shipping_address

  def count
    items.inject(0){|sum, item| sum += item.quantity }
  end

  def total
    items.inject(0.0){|sum, item| sum += (item.price.amount.to_f * item.quantity) }
  end

  def add(price, quantity=1)
    item = find_or_init_item(price)
    item.quantity = quantity
    save
    item
  end

  def remove(price_id)
    item = find_item(price_id)
    return false unless item
    items.reject!{|i| i == item}
    save
    true
  end

  def find_item(price_id)
    items.where(price_id: price_id).first
  end


  #######
  private
  #######

  def clear_zero_quantity_items
    items.destroy_all(quantity: 0)
    true
  end

  def find_or_init_item(price)
    item = find_item(price.id)
    if item.nil?
      item = items.build_from(price)
      self.items << item
    end
    item
  end
end